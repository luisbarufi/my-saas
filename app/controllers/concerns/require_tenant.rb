module RequireTenant
  extend ActiveSupport::Concern

  included do 
    before_action :require_tenant

    def require_tenant
      redirect_to root_path, alert: 'No tenant set!' if current_tenant.nil?
    end  
  end
end
