require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe 'gravatar_url' do
    it 'should return the gravatar url of the given email address' do
      url = helper.gravatar_url('Jim@Jimmy.com')
      expect(url).to eq 'http://www.gravatar.com/avatar/abc8825499c9a68be9242a4977dd7584?s=80&d=mm'
    end
  end

  describe 'gravatar_for' do
    it 'should return an image tag' do
      tag = helper.gravatar_for(User.new(name: 'jim', email: 'jim@jimmy.com'))

      expect(tag).to include '<img'
    end
  end

end
