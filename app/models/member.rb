class Member < ApplicationRecord
  belongs_to :user, counter_cache: true
  # User.find_each { |user| User.reset_counters(user.id, :members) }

  validates :tenant_id, presence: true
  validates_uniqueness_of :user_id, scope: :tenant_id

  acts_as_tenant(:tenant)
end
