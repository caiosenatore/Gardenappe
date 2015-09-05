class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :transactions

  validates :name, length: {minimum: 1, maximum: 100}
end
