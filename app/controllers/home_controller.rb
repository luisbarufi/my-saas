class HomeController < ApplicationController
  include SetTenant
  include RequireTenant

  def dashboard
  end
end
