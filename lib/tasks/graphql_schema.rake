namespace :graphql do
  desc "Generate GraphQL schema JSON file"
  task schema: :environment do
    require "graphql"

    # GraphQL introspection query to get the full schema
    introspection_query = GraphQL::Introspection::INTROSPECTION_QUERY

    result = DocumentSchema.execute(introspection_query)
    schema_json = JSON.pretty_generate(result.to_h)

    # Write to schema.json in app/graphql directory
    schema_path = Rails.root.join("app", "graphql", "schema.json")
    File.write(schema_path, schema_json)

    puts "✅ GraphQL schema written to: #{schema_path}"
    puts "   Schema size: #{schema_json.bytesize} bytes"
  end

  desc "Generate GraphQL schema in GraphQL SDL format"
  task schema_sdl: :environment do
    schema_sdl = DocumentSchema.to_definition

    # Write to schema.graphql in app/graphql directory
    schema_path = Rails.root.join("app", "graphql", "schema.graphql")
    File.write(schema_path, schema_sdl)

    puts "✅ GraphQL schema (SDL) written to: #{schema_path}"
    puts "   Schema size: #{schema_sdl.bytesize} bytes"
  end
end
