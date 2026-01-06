class Comment < ApplicationRecord
  # Validations
  validates :body, presence: true

  # Associations
  belongs_to :issue
  belongs_to :user

  # Scopes
  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
end
