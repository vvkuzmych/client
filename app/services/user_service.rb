# Service class for handling user operations through GraphQL
class UserService
  class << self
    # Read operations

    # Get all users through GraphQL query
    # @param limit [Integer] Maximum number of users to return
    # @param offset [Integer] Number of users to skip
    # @return [Array<User>] Collection of users
    def all(limit: nil, offset: 0)
      query_string = <<~GRAPHQL
        query GetUsers($limit: Int, $offset: Int) {
          users(limit: $limit, offset: $offset) {
            id
            handle
            email
            createdAt
            updatedAt
          }
        }
      GRAPHQL

      variables = {}
      variables[:limit] = limit if limit.present?
      variables[:offset] = offset if offset.positive?

      result = DocumentSchema.execute(query_string, variables: variables)
      extract_users_from_result(result)
    end

    # Find a user by ID through GraphQL query
    # @param id [Integer, String] User ID
    # @return [User, nil] User object or nil if not found
    def find(id)
      query_string = <<~GRAPHQL
        query GetUser($id: ID!) {
          user(id: $id) {
            id
            handle
            email
            createdAt
            updatedAt
          }
        }
      GRAPHQL

      result = DocumentSchema.execute(query_string, variables: { id: id.to_s })
      extract_user_from_result(result)
    end

    # Find a user by handle through GraphQL query
    # @param handle [String] User handle
    # @return [User, nil] User object or nil if not found
    def find_by_handle(handle)
      # Since we don't have a GraphQL query for handle, we'll get all and filter
      # In a real scenario, you might want to add a handle query to GraphQL
      all.find { |user| user.handle == handle }
    end

    # Find a user by email through GraphQL query
    # @param email [String] User email
    # @return [User, nil] User object or nil if not found
    def find_by_email(email)
      # Since we don't have a GraphQL query for email, we'll get all and filter
      # In a real scenario, you might want to add an email query to GraphQL
      all.find { |user| user.email == email }
    end

    # Write operations

    # Create a new user through GraphQL mutation
    # @param handle [String] User handle
    # @param email [String] User email
    # @return [User] Created user object
    # @raise [ActiveRecord::RecordInvalid] If validation fails
    def create(handle:, email:)
      mutation_string = <<~GRAPHQL
        mutation CreateUser($handle: String!, $email: String!) {
          createUser(handle: $handle, email: $email) {
            user {
              id
              handle
              email
              createdAt
              updatedAt
            }
            errors
          }
        }
      GRAPHQL

      result = DocumentSchema.execute(mutation_string, variables: { handle: handle, email: email })
      extract_user_from_mutation_result(result, :createUser)
    end

    # Update an existing user through GraphQL mutation
    # @param id [Integer, String] User ID
    # @param handle [String, nil] New handle (optional)
    # @param email [String, nil] New email (optional)
    # @return [User, nil] Updated user object or nil if not found
    # @raise [ActiveRecord::RecordInvalid] If validation fails
    def update(id:, handle: nil, email: nil)
      mutation_string = <<~GRAPHQL
        mutation UpdateUser($id: ID!, $handle: String, $email: String) {
          updateUser(id: $id, handle: $handle, email: $email) {
            user {
              id
              handle
              email
              createdAt
              updatedAt
            }
            errors
          }
        }
      GRAPHQL

      variables = { id: id.to_s }
      variables[:handle] = handle if handle.present?
      variables[:email] = email if email.present?

      result = DocumentSchema.execute(mutation_string, variables: variables)
      extract_user_from_mutation_result(result, :updateUser)
    end

    # Delete a user through GraphQL mutation
    # @param id [Integer, String] User ID
    # @return [Boolean] True if user was deleted, false if not found
    def delete(id)
      mutation_string = <<~GRAPHQL
        mutation DeleteUser($id: ID!) {
          deleteUser(id: $id) {
            success
            errors
          }
        }
      GRAPHQL

      result = DocumentSchema.execute(mutation_string, variables: { id: id.to_s })
      data = result.to_h["data"]
      return false unless data

      mutation_result = data["deleteUser"]
      return false unless mutation_result

      mutation_result["success"] == true
    end

    private

    # Extract users from GraphQL query result
    # @param result [GraphQL::Query::Result] GraphQL execution result
    # @return [Array<User>] Array of User objects
    def extract_users_from_result(result)
      data = result.to_h["data"]
      return [] unless data

      users_data = data["users"] || []
      users_data.map { |user_data| build_user_from_data(user_data) }
    end

    # Extract user from GraphQL query result
    # @param result [GraphQL::Query::Result] GraphQL execution result
    # @return [User, nil] User object or nil if not found
    def extract_user_from_result(result)
      data = result.to_h["data"]
      return nil unless data

      user_data = data["user"]
      return nil unless user_data

      build_user_from_data(user_data)
    end

    # Extract user from GraphQL mutation result
    # @param result [GraphQL::Query::Result] GraphQL execution result
    # @param mutation_name [Symbol] Name of the mutation (e.g., :createUser)
    # @return [User, nil] User object or nil if not found/error
    # @raise [ActiveRecord::RecordInvalid] If validation errors exist
    def extract_user_from_mutation_result(result, mutation_name)
      data = result.to_h["data"]
      return nil unless data

      mutation_result = data[mutation_name.to_s]
      return nil unless mutation_result

      errors = mutation_result["errors"] || []
      unless errors.empty?
        user = User.new
        errors.each { |error| user.errors.add(:base, error) }
        raise ActiveRecord::RecordInvalid, user
      end

      user_data = mutation_result["user"]
      return nil unless user_data

      build_user_from_data(user_data)
    end

    # Build a User object from GraphQL data hash
    # @param user_data [Hash] User data from GraphQL response
    # @return [User] User object
    def build_user_from_data(user_data)
      return nil unless user_data && user_data["id"]

      # Find the user by ID to get a proper ActiveRecord object
      # This ensures we have a persisted object with all associations
      user = User.find_by(id: user_data["id"])
      return nil unless user

      # Update attributes from GraphQL response to ensure consistency
      user.handle = user_data["handle"] if user_data["handle"]
      user.email = user_data["email"] if user_data["email"]
      user.created_at = Time.parse(user_data["createdAt"]) if user_data["createdAt"]
      user.updated_at = Time.parse(user_data["updatedAt"]) if user_data["updatedAt"]
      user
    end
  end
end
