require 'rails_helper'

describe 'comments/_comment_list.html.haml', type: :view do

  before(:each) do
    current_user = User.new(id: 22, name: 'Current', email: 'current@example.com')
    allow(view).to receive(:current_user).and_return current_user
  end

  it 'should display comments' do
    author = User.new(id: 42, name: 'Phil', email: 'phil@example.com')
    topic = Topic.new(id: 42)

    render partial: 'comments/comment_list', locals: { topic: topic, comments: [Comment.new(id: 1, body: 'Comments have bodies', author: author, created_at: Time.now)] }

    # Body
    expect(rendered).to include 'Comments have bodies'

    # Author
    expect(rendered).to include 'Phil'
  end

end