class Tenant < ApplicationRecord
  extend FriendlyId

  validates :name, presence: true, uniqueness: true
  validates :name, length: { in: 2..20 }

  has_many :members, dependent: :destroy
  has_many :users, through: :members
  has_many :contacts, dependent: :destroy

  friendly_id :name, use: :slugged

  def to_s
    name
  end
end
