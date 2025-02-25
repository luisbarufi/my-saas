module RequireTenant
  extend ActiveSupport::Concern

  included do 
    before_action :require_tenant

    def require_tenant
      if ActsAsTenant.current_tenant.nil?
        redirect_to root_path, alert: 'No tenant set!' 
      end
    end  
  end
end
