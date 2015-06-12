require 'rails_helper'

describe 'topics/index.html.haml', type: :view do

  before(:each) do
    @current_user = User.create(email: 'current@example.com')
    allow(view).to receive(:current_user).and_return(@current_user)
  end

  it 'should contain a list of topics' do
    ruby_topic = Topic.create(name: 'Ruby')
    assign(:topics, [ruby_topic])

    render

    expect(rendered).to include 'Ruby'
  end

  it 'should contain a link to #new' do
    assign(:topics, [])

    render

    assert_select('a[href="/topics/new"]')
  end

  it 'should have a link to sort by name' do
    assign(:topics, [])

    render

    assert_select('a[href*="/topics?"][href*="order_by=name"]')
  end

end