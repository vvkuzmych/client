class Issue < ApplicationRecord
  # Validations
  validates :status, presence: true, inclusion: { in: %w[ open closed ] }
  validates :priority, presence: true, inclusion: { in: 1..5 }
  validates :title, presence: true

  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy

  # Scopes
  scope :open, -> { where(status: "open") }
  scope :closed, -> { where(status: "closed") }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :recent, -> { order(created_at: :desc) }
end
