module Types
  class DocumentVersionType < BaseObject
    description "A version of a document"

    field :id, ID, null: false
    field :document_id, ID, null: false
    field :version_number, Integer, null: false
    field :title, String, null: false
    field :content, String, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :document, Types::DocumentType, null: false
  end
end
