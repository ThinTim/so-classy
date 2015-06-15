module ApplicationHelper

  GRAVATAR_PATH = 'http://www.gravatar.com/avatar'

  def gravatar_url(email_address, size=80)
    "#{GRAVATAR_PATH}/#{Digest::MD5.hexdigest(email_address.strip.downcase)}?s=#{size}&d=mm"
  end

  def gravatar_for(person, size=80)
    display_name = "#{person.display_name}'s avatar"
    tag = image_tag(gravatar_url(person.email, size), alt: display_name, title: display_name) {}
    tag.html_safe
  end

  def user_email_domain
    Rails.application.config.user_email_domain
  end
end
