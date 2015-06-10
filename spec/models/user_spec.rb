require 'rails_helper'

describe User, type: :model do

  describe 'valid' do

    describe 'email addresses' do

      it "should end with @#{Rails.application.config.user_email_domain}" do
        valid_user = User.new(email: "bob@#{Rails.application.config.user_email_domain}")
        invalid_user = User.new(email: 'bob@truckmonkey.com')

        expect(valid_user).to be_valid
        expect(invalid_user).not_to be_valid
      end

    end

  end

end
