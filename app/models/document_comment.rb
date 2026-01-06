class DocumentComment < ApplicationRecord
  # Validations
  validates :comment, presence: true

  # Associations
  belongs_to :document

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
end
