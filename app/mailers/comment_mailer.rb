class CommentMailer < ApplicationMailer
  def comment_notification(comment)
    @comment = comment
    @issue = comment.issue
    @comment_author = comment.user
    @issue_owner = @issue.user

    # Don't send email if comment author is the issue owner
    return unless @comment_author.id != @issue_owner.id

    mail(to: @issue_owner.email, subject: "New comment on: #{@issue.title}")
  end
end
