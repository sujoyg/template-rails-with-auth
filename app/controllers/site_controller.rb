class SiteController < ApplicationController
  def home
    if current_user
      render 'users/home'
    else
      render 'site/home'
    end
  end
end
