class DocumentVersion < ApplicationRecord
  # Validations
  validates :version_number, presence: true, uniqueness: { scope: :document_id }
  validates :title, presence: true

  # Associations
  belongs_to :document

  # Scopes
  scope :ordered, -> { order(version_number: :desc) }
end
