class UserMailer < ApplicationMailer
  def sign_in(user)
    @user = user
    mail(to: user.email, subject: 'Sign in to SoClassy')
  end

  def email_comment(comment, topic)
    @comment = comment
    @topic = topic
    mail(to: @topic.members.collect(&:email), subject: "New comment about #{@topic.name} on SoClassy")
  end
end
