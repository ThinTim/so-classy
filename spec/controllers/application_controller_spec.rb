require 'rails_helper'

describe ApplicationController, type: :controller do

  describe 'current_user' do

   context 'when there is a user_id cookie' do

     before :each do
       @user = User.create(name: 'Jim', email: 'jim@example.com')
       session[:user_id] = @user.id
     end

     it 'should find user' do
       expect(subject.current_user).to eq @user
     end

   end

   context 'when there is no user_id cookie' do

     it 'should return nil' do
       expect(subject.current_user).to be_nil
     end

   end

 end

end