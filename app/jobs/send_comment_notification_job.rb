class SendCommentNotificationJob < ApplicationJob
  queue_as :default

  discard_on ActiveJob::DeserializationError

  def perform(comment_id)
    comment = Comment.includes(:issue, :user).find_by(id: comment_id)
    return unless comment
    return unless comment.issue
    return unless comment.user

    # Don't send if comment author is the issue owner
    return if comment.user_id == comment.issue.user_id

    CommentMailer.comment_notification(comment).deliver_now
  end
end
