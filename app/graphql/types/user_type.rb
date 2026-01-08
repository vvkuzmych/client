module Types
  class UserType < BaseObject
    description "A user in the system"

    field :id, ID, null: false
    field :handle, String, null: false
    field :email, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
