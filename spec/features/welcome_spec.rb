require 'rails_helper'

describe 'welcome', :type => :feature do
  it 'welcomes us to SoClassy' do
    visit '/'
    expect(page).to have_text 'Welcome to SoClassy'
  end
end