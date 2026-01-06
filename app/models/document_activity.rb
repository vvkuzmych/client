class DocumentActivity < ApplicationRecord
  # Validations
  validates :activity_type, presence: true
  validates :activity_type, inclusion: { 
    in: %w[created updated reviewed approved rejected commented archived] 
  }

  # Associations
  belongs_to :document

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(activity_type: type) }
end

