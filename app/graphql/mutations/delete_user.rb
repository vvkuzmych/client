module Mutations
  class DeleteUser < Types::BaseMutation
    description "Delete a user"

    argument :id, ID, required: true, description: "The user ID"

    field :success, Boolean, null: false, description: "Whether the deletion was successful"
    field :errors, [String], null: false, description: "List of errors if deletion failed"

    def resolve(id:)
      success = UserService.delete(id)
      if success
        {
          success: true,
          errors: []
        }
      else
        {
          success: false,
          errors: ["User not found"]
        }
      end
    rescue StandardError => e
      {
        success: false,
        errors: [e.message]
      }
    end
  end
end
