# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  handle     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_handle  (handle) UNIQUE
#
class User < ApplicationRecord
  # Validations
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: false

  # Associations
  has_many :issues, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Scopes
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  after_create :send_welcome_email

  private

  def send_welcome_email
    SendWelcomeEmailJob.perform_later(id)
  end
end
