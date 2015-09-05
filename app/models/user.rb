class User < ActiveRecord::Base
  include BCrypt

  has_and_belongs_to_many :groups

  has_secure_password

  validates :fullname, :length => {minimum: 3, maximum: 130}
  validates :email, :length => {minimum: 2, maximum: 100}, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
  validates_uniqueness_of :email
  validates :password, confirmation: true
end
