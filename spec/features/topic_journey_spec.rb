require 'rails_helper'

xdescribe 'topic', :type => :feature do
  let(:user) { User.create!(email: 'jona@example.com', token: SecureRandom.hex) }
  let(:create_a_topic_link) { find('a[data-name="create-a-topic-link"]') }

  it 'is created' do
    visit "/sessions/#{user.id}/authenticate?token=#{user.token}"
    create_a_topic_link.click
    fill_in 'topic_name', with: 'Test Driven Development'
    fill_in 'topic_description', with: 'Building applications by writing tests before implementation'
    click_button 'Save'
    expect(page).to have_text "Test Driven Development by #{user.email}"
  end
end