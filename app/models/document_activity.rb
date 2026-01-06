# == Schema Information
#
# Table name: document_activities
#
#  id              :bigint           not null, primary key
#  activity_type   :string           not null
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  document_id     :bigint           not null
#  performed_by_id :integer
#
# Indexes
#
#  index_document_activities_on_activity_type    (activity_type)
#  index_document_activities_on_document_id      (document_id)
#  index_document_activities_on_performed_by_id  (performed_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
class DocumentActivity < ApplicationRecord
  # Validations
  validates :activity_type, presence: true
  validates :activity_type, inclusion: {
    in: %w[ created updated reviewed approved rejected commented archived ]
  }

  # Associations
  belongs_to :document

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(activity_type: type) }
end
