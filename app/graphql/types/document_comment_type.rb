module Types
  class DocumentCommentType < BaseObject
    description "A comment on a document"

    field :id, ID, null: false
    field :document_id, ID, null: false
    field :author_id, Integer, null: true
    field :comment, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :document, Types::DocumentType, null: false
  end
end
