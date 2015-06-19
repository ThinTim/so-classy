require 'rails_helper'

describe 'topics/show.html.haml', type: :view do

  let(:morty_owner) { User.new(id: 44, name: 'Morty', email: 'morty@example.com') }
  let(:rick_non_owner) { User.new(id: 43, name: 'Rick', email: 'rick@example.com') }
  let(:topic) { Topic.new(name: 'Topic Name', id: 42, owner: morty_owner, description: 'Yep, it\'s a topic') }

  before(:each) do
    allow(view).to receive(:current_user)
    allow(view).to receive(:current_user?)

    assign(:topic, topic)
  end

  it 'should display topic name' do
    render

    expect(rendered).to include 'Topic Name'
  end

  it 'should display topic description' do
    render

    expect(rendered).to include 'Yep, it\'s a topic'
  end

  it 'should list teachers' do
    topic.students = []
    topic.teachers = [rick_non_owner]
    
    render

    expect(rendered).to include 'Rick'
  end

  it 'should list students' do
    topic.students = [rick_non_owner]
    topic.teachers = []

    render

    expect(rendered).to include 'Rick'
  end

  context 'when the user is a teacher' do
    it 'should have a stop teaching button' do
      allow(view).to receive(:current_user).and_return(rick_non_owner)
      allow(view).to receive(:current_user?).with(rick_non_owner).and_return(true)
      allow(view).to receive(:current_user?).with(any_args).and_return(false)

      topic.teachers = [rick_non_owner]

      render

      expect(rendered).to include 'Stop Volunteering'
    end
  end

  context 'when the user is not a teacher' do
    it 'should have a volunteer button' do
      allow(view).to receive(:current_user).and_return(rick_non_owner)
      allow(view).to receive(:current_user?).with(rick_non_owner).and_return(true)
      allow(view).to receive(:current_user?).with(any_args).and_return(false)

      topic.teachers = []

      render

      expect(rendered).to include 'Volunteer'
    end
  end

  context 'when the user is a learner' do
    it 'should have a stop learning button' do
      allow(view).to receive(:current_user).and_return(rick_non_owner)
      allow(view).to receive(:current_user?).with(rick_non_owner).and_return(true)
      allow(view).to receive(:current_user?).with(any_args).and_return(false)

      topic.students = [rick_non_owner]

      render

      expect(rendered).to include 'Unenroll'
    end
  end

  context 'when the user is not a learner' do
    it 'should have a learn button' do
      allow(view).to receive(:current_user).and_return(rick_non_owner)
      allow(view).to receive(:current_user?).with(rick_non_owner).and_return(true)
      allow(view).to receive(:current_user?).with(any_args).and_return(false)
      
      topic.students = []

      render

      expect(rendered).to include 'Enroll'
    end
  end

end