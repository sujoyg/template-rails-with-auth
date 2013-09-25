require 'spec_helper'

describe 'site/home' do
  it 'should render a login form.' do
    render
    rendered.should contain 'Log In'
    rendered.should render_template(partial: 'shared/_login')
  end

  it 'should render a signup form.' do
    render
    rendered.should have_selector 'h2', content: 'Sign Up'
    rendered.should render_template(partial: 'shared/_signup')
  end
end