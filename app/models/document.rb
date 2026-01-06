class Document < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :status, inclusion: { in: %w[draft review approved rejected archived] }

  # Associations
  has_many :document_versions, dependent: :destroy
  has_many :document_comments, dependent: :destroy
  has_many :document_activities, dependent: :destroy

  # Scopes
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def current_version
    document_versions.order(version_number: :desc).first
  end

  def latest_version_number
    document_versions.maximum(:version_number) || 0
  end
end

