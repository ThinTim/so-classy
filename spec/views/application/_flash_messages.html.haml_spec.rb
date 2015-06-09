require 'rails_helper'

describe 'application/_flash_messages.html.haml', type: :view do

  it 'should render alerts for each flash message' do
    flash[:info] = 'foo'
    flash[:warn] = 'bar'

    render

    assert_select '.alert', 2
  end

  it 'should render :warn and :warning as ".alert-warning"' do
    flash[:warn] = 'foo'
    flash[:warning] = 'bar'

    render

    assert_select '.alert-warning', 2
  end

  it 'should render :danger and :error as ".alert-danger"' do
    flash[:danger] = 'foo'
    flash[:error] = 'bar'

    render

    assert_select '.alert-danger', 2
  end

  it 'should render :success as ".alert-success"' do
    flash[:success] = 'foo'

    render

    assert_select '.alert-success', 1
  end

  it 'should render any other key as ".alert-info"' do
    flash[:foo] = 'foo'

    render

    assert_select '.alert-info', 1
  end
end