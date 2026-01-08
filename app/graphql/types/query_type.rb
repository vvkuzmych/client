module Types
  class QueryType < BaseObject
    description "The query root of this schema"

    # Get all documents
    field :documents, [ Types::DocumentType ], null: false, description: "Returns all documents" do
      argument :status, String, required: false, description: "Filter by status"
      argument :limit, Integer, required: false, description: "Limit the number of results", default_value: 10
    end

    # Get a single document by ID
    field :document, Types::DocumentType, null: true, description: "Returns a single document" do
      argument :id, ID, required: true, description: "The document ID"
    end

    # Get document versions
    field :document_versions, [ Types::DocumentVersionType ], null: false, description: "Returns versions for a document" do
      argument :document_id, ID, required: true, description: "The document ID"
    end

    # Get document comments
    field :document_comments, [ Types::DocumentCommentType ], null: false, description: "Returns comments for a document" do
      argument :document_id, ID, required: true, description: "The document ID"
    end

    # Get document activities
    field :document_activities, [ Types::DocumentActivityType ], null: false, description: "Returns activities for a document" do
      argument :document_id, ID, required: true, description: "The document ID"
      argument :activity_type, String, required: false, description: "Filter by activity type"
    end

    # Get all users
    field :users, [ Types::UserType ], null: false, description: "Returns all users" do
      argument :limit, Integer, required: false, description: "Limit the number of results"
      argument :offset, Integer, required: false, description: "Number of users to skip", default_value: 0
    end

    # Get a single user by ID
    field :user, Types::UserType, null: true, description: "Returns a single user" do
      argument :id, ID, required: true, description: "The user ID"
    end

    def documents(status: nil, limit: 10)
      query = Document.all
      query = query.where(status: status) if status.present?
      query.limit(limit).order(created_at: :desc)
    end

    def document(id:)
      Document.find_by(id: id)
    end

    def document_versions(document_id:)
      DocumentVersion.where(document_id: document_id).order(version_number: :desc)
    end

    def document_comments(document_id:)
      DocumentComment.where(document_id: document_id).order(created_at: :desc)
    end

    def document_activities(document_id:, activity_type: nil)
      query = DocumentActivity.where(document_id: document_id)
      query = query.where(activity_type: activity_type) if activity_type.present?
      query.order(created_at: :desc)
    end

    def users(limit: nil, offset: 0)
      UserService.all(limit: limit, offset: offset)
    end

    def user(id:)
      UserService.find(id)
    end
  end
end
