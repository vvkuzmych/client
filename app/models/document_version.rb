# == Schema Information
#
# Table name: document_versions
#
#  id             :bigint           not null, primary key
#  content        :text
#  title          :string           not null
#  version_number :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  document_id    :bigint           not null
#
# Indexes
#
#  index_document_versions_on_document_id                     (document_id)
#  index_document_versions_on_document_id_and_version_number  (document_id,version_number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
class DocumentVersion < ApplicationRecord
  # Validations
  validates :version_number, presence: true, uniqueness: { scope: :document_id }
  validates :title, presence: true

  # Associations
  belongs_to :document

  # Scopes
  scope :ordered, -> { order(version_number: :desc) }
end
