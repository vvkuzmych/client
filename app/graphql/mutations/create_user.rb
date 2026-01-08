module Mutations
  class CreateUser < Types::BaseMutation
    description "Create a new user"

    argument :handle, String, required: true, description: "User handle"
    argument :email, String, required: true, description: "User email"

    field :user, Types::UserType, null: true, description: "The created user"
    field :errors, [String], null: false, description: "List of errors if creation failed"

    def resolve(handle:, email:)
      user = UserService.create(handle: handle, email: email)
      {
        user: user,
        errors: []
      }
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
