require 'rails_helper'

describe 'topic journey', type: :feature do
  let(:user) { User.create!(email: 'jona@example.com', token: SecureRandom.hex) }
  let(:create_a_topic_link) { find('a[data-name="create-a-topic-link"]') }

  it do
    login
    create_a_topic
    comment_with_email
  end

  def login
    visit "/sessions/#{user.id}/authenticate?token=#{user.token}"
  end

  def create_a_topic
    create_a_topic_link.click
    fill_in 'topic_name', with: 'Test Driven Development'
    fill_in 'topic_description', with: 'Building applications by writing tests before implementation'
    click_button 'Save'
  end

  def comment_with_email
    fill_in 'Comment', with: "We're in a tight spot!"
    check 'Email'
    click_button 'Submit'
    expect(page).to have_text "We're in a tight spot!"
  end
end