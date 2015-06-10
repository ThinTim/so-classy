class User < ActiveRecord::Base
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_format_of :email, with: /@#{Rails.application.config.user_email_domain}\z/
end
