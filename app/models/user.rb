class User < ApplicationRecord
  devise :database_authenticatable, :invitable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_photo

  has_many :subscriptions, dependent: :destroy
  has_many :invoices, dependent: :destroy

  enum :role, { buyer: 'buyer', admin: 'admin' }
end