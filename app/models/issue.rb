# == Schema Information
#
# Table name: issues
#
#  id         :bigint           not null, primary key
#  priority   :integer          not null
#  status     :string           not null
#  title      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_issues_on_status   (status)
#  index_issues_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
