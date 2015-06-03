require 'rails_helper'

describe 'skills/new.html.haml', type: :view do

  it 'should display a form' do
    render

    assert_select('form[action="/skills"][method="post"]')
    assert_select('input[type="text"][name="skill[name]"]')
    assert_select('input[type="submit"]')
  end

end