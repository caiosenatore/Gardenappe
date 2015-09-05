class Transaction < ActiveRecord::Base
  has_and_belongs_to_many :groups

  validates :name, length: {minimum: 1, maximum: 100}
end
