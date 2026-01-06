class GraphqlController < ApplicationController
  # CSRF protection is enabled by default via ApplicationController
  # Clients must send CSRF token in X-CSRF-Token header or as authenticity_token param

  # GET endpoint to retrieve CSRF token for API clients
  def csrf_token
    render json: { csrf_token: form_authenticity_token }
  end

  def execute
    # Parse JSON body if present, otherwise use params
    request_data = if request.content_type&.include?("application/json")
      body = request.body.read
      request.body.rewind
      body.present? ? JSON.parse(body) : {}
    else
      params.to_unsafe_h
    end

    variables = prepare_variables(request_data[:variables] || request_data["variables"])
    query = request_data[:query] || request_data["query"]
    operation_name = request_data[:operationName] || request_data["operationName"]

    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = DocumentSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue JSON::ParserError => e
    render json: { errors: [ { message: "Invalid JSON: #{e.message}" } ] }, status: 400
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a URL query string
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end
end
