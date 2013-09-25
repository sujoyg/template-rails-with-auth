require 'spec_helper'

describe 'layouts/_header' do
  it 'should render a logout link when logged in.' do
    view.stub(:current_user).and_return(build :user)

    render
    rendered.should have_selector 'a', href: logout_path, content: 'Logout'
  end

  it 'should not render a logout link when not logged in.' do
    render
    rendered.should_not have_selector 'a', href: logout_path
  end
end