module ApplicationHelper

  GRAVATAR_PATH = 'http://www.gravatar.com/avatar'

  def gravatar_url(email_address, size=80)
    "#{GRAVATAR_PATH}/#{Digest::MD5.hexdigest(email_address.strip.downcase)}?s=#{size}&d=mm"
  end

  def gravatar_for(user, size=80)
    avatar = content_tag(:a, href: user_path(user)) do
      image_tag(gravatar_url(user.email, size), alt: user.display_name, title: user.display_name) 
    end
    avatar.html_safe
  end

  def user_email_domain
    Rails.application.config.user_email_domain
  end
end
