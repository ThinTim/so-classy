class UserMailer < ApplicationMailer

  def sign_in(user)
    @user = user
    mail(to: user.email, subject: 'Sign in to SoClassy')
  end

end
