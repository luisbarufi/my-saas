class Member < ApplicationRecord
  belongs_to :user, counter_cache: true

  validates :tenant_id, presence: true
  validates_uniqueness_of :user_id, scope: :tenant_id
  validate :must_have_a_role, on: :update
  validate :must_have_an_admin

  acts_as_tenant(:tenant)

  ROLES = [:admin, :editor, :viewer]

  store_accessor :roles, *ROLES

  ROLES.each do |role|
    scope role, -> { where("roles @> ?", {role => true}.to_json) }
    define_method(:"#{role}=") { |value| super ActiveRecord::Type::Boolean.new.cast(value) }
    define_method(:"#{role}?") { send(role) }
  end

  def active_roles
    ROLES.select { |role| send(:"#{role}?") }.compact
  end

  private

  def must_have_a_role
    if self.roles.values.none?
      errors.add(:base, "A member must have at least one role")
    end
  end

  def must_have_an_admin
    if (self.tenant.members.pluck(:roles).count { |h| h[:'admim'] == true } == 1) && (roles_changed? && admim == false)
      errors.add(:base, "The tenant has to have at least one admim")
    end
  end
end
