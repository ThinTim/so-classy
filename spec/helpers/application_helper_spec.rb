require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SkillsHelper. For example:
#
# describe SkillsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ApplicationHelper, type: :helper do

  describe 'current_user' do

    context 'when there is a user_id cookie' do

      before :each do
        @user = User.create(name: 'Jim', email: 'jim@example.com')
        cookies[:user_id] = @user.id
      end

      it 'should find user' do
        expect(helper.current_user).to eq @user
      end

    end

    context 'when there is no user_id cookie' do

      it 'should return nil' do
        expect(helper.current_user).to be_nil
      end

    end

  end

end
