require 'rails_helper'

describe 'topics/show.html.haml', type: :view do

  let(:ruby_topic) { Topic.new(name: 'Ruby', id: 42) }
  let(:user) { User.new(name: 'Mick', email: 'mick@example.com') }

  before(:each) do
    allow(view).to receive(:current_user).and_return(user)
  end

  it 'should display topic name' do
    assign(:topic, ruby_topic)

    render

    expect(rendered).to include 'Ruby'
  end

  it 'should have a back to topics button' do
    assign(:topic, ruby_topic)

    render

    assert_select('a[href="/topics"]')
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

    context 'when the user is a teacher already' do
      it 'should have a stop teaching button' do
        assign(:topic, java_topic)

        java_topic.teachers << user

        render

        assert_select('button', 'Stop Volunteering')
      end
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

    context 'when the user is a student already' do
      it 'should have a stop learning button' do
        assign(:topic, java_topic)

        java_topic.students << user

        render

        assert_select('button', 'Unenroll')
      end
    end

    it 'should list students' do
      assign(:topic, java_topic)

      render

      expect(rendered).to include 'Timmy'
    end

  end

end