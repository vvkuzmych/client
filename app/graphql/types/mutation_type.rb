module Types
  class MutationType < BaseObject
    description "The mutation root of this schema"

    field :create_user, mutation: Mutations::CreateUser
    field :update_user, mutation: Mutations::UpdateUser
    field :delete_user, mutation: Mutations::DeleteUser
  end
end
