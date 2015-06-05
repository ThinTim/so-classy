require 'rails_helper'

describe 'topics/show.html.haml', type: :view do

  let(:ruby_topic) { Topic.new(name: 'Ruby', id: 42) }

  it 'should display topic name' do
    assign(:topic, ruby_topic)

    render

    expect(rendered).to include 'Ruby'
  end

  describe 'teaching' do

    let(:java_topic) {
      Topic.new(
          name: 'Java',
          id: 42,
          teachers: [User.new(name: 'Jimmy', email: 'jimmy@example.com')]
      )
    }

    it 'should have a teach button' do
      assign(:topic, java_topic)

      render

      assert_select('button', 'Volunteer')
    end

    it 'should list teachers' do
      assign(:topic, java_topic)

      render

      expect(rendered).to include 'Jimmy'
    end

  end

  describe 'learning' do

    let(:java_topic) {
      Topic.new(
          name: 'Java',
          id: 42,
          students: [User.new(name: 'Timmy', email: 'timmy@example.com')]
      )
    }

    it 'should have a learn button' do
      assign(:topic, java_topic)

      render

      assert_select('button', 'Enroll')
    end

    it 'should list students' do
      assign(:topic, java_topic)

      render

      expect(rendered).to include 'Timmy'
    end

  end

end