class User < ApplicationRecord
  # Validations
  validates :handle, presence: true, uniqueness: true

  # Associations
  has_many :issues, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
end
