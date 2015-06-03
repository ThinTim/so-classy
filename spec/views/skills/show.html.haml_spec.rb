require 'rails_helper'

describe 'skills/show.html.haml', type: :view do

  it 'should display skill name' do
    ruby_skill = Skill.new(name: 'Ruby')
    assign(:skill, ruby_skill)

    render

    expect(rendered).to include 'Ruby'
  end

end