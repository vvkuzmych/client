# == Schema Information
#
# Table name: document_comments
#
#  id          :bigint           not null, primary key
#  comment     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :integer
#  document_id :bigint           not null
#
# Indexes
#
#  index_document_comments_on_author_id    (author_id)
#  index_document_comments_on_document_id  (document_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
class DocumentComment < ApplicationRecord
  # Validations
  validates :comment, presence: true

  # Associations
  belongs_to :document

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
end
