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

      it 'should prevent duplicate emails caused by case differences' do
        domain = Rails.application.config.user_email_domain

        valid_user = User.create(email: "bob@#{domain}")
        duplicate_user =  User.create(email: "BOB@#{domain}")

        expect(duplicate_user.valid?).to eq false
      end

      it 'should canonicalise emails' do
        domain = Rails.application.config.user_email_domain

        valid_user = User.create(email: "BOB@#{domain}")

        expect(valid_user.email).to eq "bob@#{domain}"
      end

    end

  end

  describe 'display_name' do
    it 'should return the user\'s name if available' do
      user = User.new(name: 'Jim', email: 'jim@example.com')

      expect(user.display_name).to eq 'Jim'
    end

    it 'should return the user\'s email if the name is not available' do
      user = User.new(name: '', email: 'jim@example.com')

      expect(user.display_name).to eq 'jim@example.com'
    end
  end

  describe 'to_xml' do
    it 'should exclude the user\'s token' do
      user = User.create(email: 'token@example.com', token: SecureRandom.hex)
      
      expect(user.to_xml).not_to include user.token
    end
  end

  describe 'as_json' do
    it 'should exclude the user\'s token' do
      user = User.create(email: 'token@example.com', token: SecureRandom.hex)

      expect(user.as_json).not_to include user.token
    end
  end

end
