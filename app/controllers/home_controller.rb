class HomeController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]

  def index
  end

  #include SetTenant
  #include RequireTenant

  def dashboard
  end

  set_current_tenant_through_filter
  before_action :set_tenant, only: :dashboard

  def set_tenant
    return set_current_tenant(nil) unless current_user
  
    tenant = current_user.tenant
    if tenant.present? && current_user.tenants.include?(tenant)
      set_current_tenant(tenant)
    else
      set_current_tenant(nil)
    end
  end
end
