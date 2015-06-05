require 'rails_helper'

describe 'topics/show.html.haml', type: :view do

  let(:ruby_topic) { 
    Topic.new(
        name: 'Ruby', 
        id: 42,
        teachers: [User.new(name: 'Jimmy', email: 'jimmy@example.com')],
        # students: [User.new(name: 'Timmy', email: 'timmy@example.com')]
      ) 
  }

  it 'should display topic name' do
    assign(:topic, ruby_topic)

    render

    expect(rendered).to include 'Ruby'
  end

  it 'should have a teach button' do
    assign(:topic, ruby_topic)

    render

    assert_select('button', 'I can teach this!')
  end

  it 'should list teachers' do
    assign(:topic, ruby_topic)

    render

    expect(rendered).to include 'Jimmy'
    expect(rendered).to include 'jimmy@example.com'
  end

  it 'should have a learn button' do
    assign(:topic, ruby_topic)

    render

    assert_select('button', 'I want to learn this!')
  end

  xit 'should list students' do
    assign(:topic, ruby_topic)

    render

    expect(rendered).to include 'Timmy'
    expect(rendered).to include 'timmy@example.com'
  end

end