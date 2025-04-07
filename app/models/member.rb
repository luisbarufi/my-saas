class Member < ApplicationRecord
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :members) }

  validates :tenant_id, presence: true
  validates_uniqueness_of :user_id, scope: :tenant_id

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
end
