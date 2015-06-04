require 'rails_helper'

describe 'topics/new.html.haml', type: :view do

  it 'should display a form' do
    render

    assert_select('form[action="/topics"][method="post"]')
    assert_select('input[type="text"][name="topic[name]"]')
    assert_select('input[type="submit"]')
  end

end