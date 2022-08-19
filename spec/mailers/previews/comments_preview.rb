# Preview all emails at http://localhost:3000/rails/mailers/comments
class CommentsPreview < ActionMailer::Preview
  def new_mention
    @user = Worker.last
    @comment = Comment.first
    CommentsMailer.with(mentioned: @user,
                        comment: @comment).new_mention
  end
end
