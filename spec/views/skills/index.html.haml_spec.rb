require 'rails_helper'

describe 'skills/index.html.haml', type: :view do

  it 'should contain a list of skills' do
    ruby_skill = Skill.new(name: 'Ruby')
    assign(:skills, [ruby_skill])

    render

    expect(rendered).to include 'Ruby'
  end

end