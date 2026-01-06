module Types
  class DocumentType < BaseObject
    description "A document in the document flow system"

    field :id, ID, null: false
    field :title, String, null: false
    field :content, String, null: true
    field :status, String, null: false
    field :author_id, Integer, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    
    # Associations
    field :versions, [Types::DocumentVersionType], null: false
    field :comments, [Types::DocumentCommentType], null: false
    field :activities, [Types::DocumentActivityType], null: false
    field :current_version, Types::DocumentVersionType, null: true
  end
end

