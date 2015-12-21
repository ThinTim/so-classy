require 'rails_helper'

CREATE_A_TOPIC_LINK = '[data-name="create-a-topic-link"]'

describe 'topic journey', type: :feature do
  let(:user) { User.create!(email: 'jona@example.com', token: SecureRandom.hex) }

  example {
    login
    create_a_topic
    comment
  }

  def login
    visit "/sessions/#{user.id}/authenticate?token=#{user.token}"
  end

  def create_a_topic
    find(CREATE_A_TOPIC_LINK).click
    fill_in 'topic_name', with: 'Test Driven Development'
    fill_in 'topic_description', with: 'Building applications by writing tests before implementation'
    click_button 'Save'
  end

  def comment
    fill_in 'Comment', with: "We're in a tight spot!"
    click_button 'Submit'
  end
end