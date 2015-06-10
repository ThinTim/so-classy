module ApplicationHelper

  GRAVATAR_PATH = 'http://www.gravatar.com/avatar'

  def gravatar_url(email_address)
    "#{GRAVATAR_PATH}/#{Digest::MD5.hexdigest(email_address.strip.downcase)}"
  end

  def user_email_domain
    Rails.application.config.user_email_domain
  end
end
