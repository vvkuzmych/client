module Types
  class DocumentActivityType < BaseObject
    description "An activity log entry for a document"

    field :id, ID, null: false
    field :document_id, ID, null: false
    field :activity_type, String, null: false
    field :description, String, null: true
    field :performed_by_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :document, Types::DocumentType, null: false
  end
end
