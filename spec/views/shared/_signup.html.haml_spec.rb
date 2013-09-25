require 'spec_helper'

describe 'shared/_signup' do
  it 'should have a signup form.' do
    render
    rendered.should have_selector('form', action: signup_path, method: 'post') do |form|
      form.should have_selector('input', type: 'text', name: 'email')
      form.should have_selector('label', for: 'email', content: 'Your Email')
      form.should have_selector('input', type: 'text', name: 'email_confirmation')
      form.should have_selector('label', for: 'email_confirmation', content: 'Re-enter Email')

      form.should have_selector('input', type: 'password', name: 'password')
      form.should have_selector('label', for: 'password', content: 'Password')

      form.should have_selector('input', type: 'submit', value: 'Sign Up')
    end
  end
end