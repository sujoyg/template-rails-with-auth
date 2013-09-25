require 'spec_helper'

describe 'users/home' do
  it 'should render a message.' do
    render
    rendered.should contain 'Hello, World.'
  end
end