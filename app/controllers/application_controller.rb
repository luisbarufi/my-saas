class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  set_current_tenant_through_filter
  before_action :set_tenant

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
