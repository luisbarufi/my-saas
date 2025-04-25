class Tenant < ApplicationRecord
  extend FriendlyId
  RESERVED_NAMES = %w(blog app pricing terms help support tenant tenants user users sex organization)
  RESERVED_PLANS = %w(solo team)
  PLANS = [:solo, :team]

  validates :name, presence: true, uniqueness: true
  validates :name, length: { in: 2..20 }
  validates :name, exclusion: { in: RESERVED_NAMES, message: "%{value} is reserved" }
  validates :plan, presence: true
  validates :plan, inclusion: { in: RESERVED_PLANS, message: "%{value} is not available" }

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :contacts, dependent: :destroy

  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  def to_s
    name
  end
end
