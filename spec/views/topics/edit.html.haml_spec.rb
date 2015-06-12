require 'rails_helper'

describe 'topics/edit.html.haml', type: :view do

  let(:morty_owner) { User.new(name: 'Morty', email: 'morty@example.com') }
  let(:topic) { Topic.new(name: 'Topic Name', id: 42, owner: morty_owner, description: 'Yep, it\'s a topic') }

  before(:each) do
    allow(view).to receive(:current_user).and_return(morty_owner)
    assign(:topic, topic)
  end

  it 'should display a delete button' do
      render

      expect(rendered).to include 'Delete this topic'
    end

  it 'should have inputs for the name and description' do
    render

    assert_select('input[name="topic[name]"]')
    assert_select('textarea[name="topic[description]"]')
  end

end