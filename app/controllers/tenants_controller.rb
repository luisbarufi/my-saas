class TenantsController < ApplicationController
  before_action :set_tenant, only: %i[ show edit update destroy switch ]
  before_action :require_admin, only: %i[ edit update destroy ]
  before_action :require_member, only: %i[ show ]

  set_current_tenant_through_filter

  # GET /tenants or /tenants.json
  def index
    @tenants = Tenant.includes(:members, :users, members: [:user])
  end

  def switch
    if current_user.tenants.include?(@tenant)
      current_user.update_attribute(:tenant_id, @tenant.id)
      redirect_to my_tenants_path, notice: "Switched to tenant: #{current_user.tenant.name}"
    else
      redirect_to my_tenants_path, alert: "You are not authorized to access tenant: #{@tenant.name}"
    end
  end

  def my
    @tenants = current_user.tenants
    render 'index'
  end

  # GET /tenants/1 or /tenants/1.json
  def show
    set_current_tenant(@tenant)
  end

  # GET /tenants/new
  def new
    @tenant = Tenant.new
  end

  # GET /tenants/1/edit
  def edit
  end

  # POST /tenants or /tenants.json
  def create
    @tenant = Tenant.new(tenant_params)

    respond_to do |format|
      if @tenant.save
        @member = Member.create!(tenant: @tenant, user: current_user, admin: true)
        current_user.update_attribute(:tenant_id, @tenant.id)
        format.html { redirect_to @tenant, notice: "Tenant was successfully created." }
        format.json { render :show, status: :created, location: @tenant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tenants/1 or /tenants/1.json
  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to @tenant, notice: "Tenant was successfully updated." }
        format.json { render :show, status: :ok, location: @tenant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tenants/1 or /tenants/1.json
  def destroy
    @tenant.destroy

    respond_to do |format|
      format.html { redirect_to my_tenants_path, status: :see_other, notice: "Tenant was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tenant_params
      params.require(:tenant).permit(:name)
    end

    def require_admin
      return if current_user.tenants.include?(@tenant) && Member.find_by(user: current_user, tenant: @tenant).admin?
    
      redirect_to tenants_path, alert: "You are not authorized"
    end

    def require_member
      return if current_user.tenants.include?(@tenant)

      redirect_to tenants_path, alert: "You are not authorized"
    end
end
