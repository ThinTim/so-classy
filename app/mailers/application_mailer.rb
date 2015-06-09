class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@so-classy.herokuapp.com'
  layout 'mailer'
end
