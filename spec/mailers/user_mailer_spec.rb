require "rails_helper"

describe UserMailer, type: :mailer do
  
  describe 'sign_in' do
    
    it 'should generate email to user' do
      dave = User.new(id: 42, name: 'Dave', email: 'dave@example.com', token: SecureRandom.hex )
      email = UserMailer.sign_in(dave)
      expect(email.from).to include 'no-reply@so-classy.herokuapp.com'
      expect(email.to).to include dave.email
      expect(email.subject).to eq 'Sign in to SoClassy'
    end

  end

end
