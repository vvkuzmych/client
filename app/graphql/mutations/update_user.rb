module Mutations
  class UpdateUser < Types::BaseMutation
    description "Update an existing user"

    argument :id, ID, required: true, description: "The user ID"
    argument :handle, String, required: false, description: "New user handle"
    argument :email, String, required: false, description: "New user email"

    field :user, Types::UserType, null: true, description: "The updated user"
    field :errors, [String], null: false, description: "List of errors if update failed"

    def resolve(id:, handle: nil, email: nil)
      user = UserService.update(id: id, handle: handle, email: email)
      if user
        {
          user: user,
          errors: []
        }
      else
        {
          user: nil,
          errors: ["User not found"]
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      {
        user: nil,
        errors: e.record.errors.full_messages
      }
    rescue StandardError => e
      {
        user: nil,
        errors: [e.message]
      }
    end
  end
end
