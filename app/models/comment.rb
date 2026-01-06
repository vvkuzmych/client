# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  archived   :boolean          default(FALSE), not null
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  issue_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_comments_on_archived      (archived)
#  index_comments_on_issue_id      (issue_id)
#  index_comments_on_user_id       (user_id)
#  ix_comments_issue_created       (issue_id,created_at,id)
#  ix_comments_issue_user_created  (issue_id,user_id,created_at,id)
#  ix_comments_user_created        (user_id,created_at,id)
#
# Foreign Keys
#
#  fk_rails_...  (issue_id => issues.id)
#  fk_rails_...  (user_id => users.id)
#
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
