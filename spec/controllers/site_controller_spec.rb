require 'spec_helper'

describe SiteController do
  describe '#home' do
    it 'should render site/home if not logged in.' do
      get :home

      response.should be_success
      response.should render_template "site/home"
    end

    it 'should render users/home if logged in.' do
      controller.stub(:current_user).and_return(build :user)

      get :home

      response.should be_success
      response.should render_template "users/home"
    end
  end
end
