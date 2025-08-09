class User < ApplicationRecord
  extend FriendlyId
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :invitable, :confirmable

  has_many :members
  has_many :tenants, through: :members

  belongs_to :tenant, required: false

  friendly_id :email, use: :slugged

  def to_s
    email
  end
end
