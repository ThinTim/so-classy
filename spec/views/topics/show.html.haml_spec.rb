require 'rails_helper'

describe 'topics/show.html.haml', type: :view do

  it 'should display topic name' do
    ruby_topic = Topic.new(name: 'Ruby')
    assign(:topic, ruby_topic)

    render

    expect(rendered).to include 'Ruby'
  end

end