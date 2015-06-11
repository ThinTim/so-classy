class User < ActiveRecord::Base
  validates_uniqueness_of :email, :case_sensitive => false
  validates_presence_of :email
  validates_format_of :email, with: /@#{Rails.application.config.user_email_domain}\z/

  before_validation :canonicalise_email

  private 

  def canonicalise_email
    self.email = self.email.strip.downcase if self.email.present?
  end
end
