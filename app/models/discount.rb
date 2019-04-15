class Discount < ApplicationRecord
  belongs_to :user, foreign_key: 'merchant_id'

  validates_presence_of :name

  validates :discount, presence: true, numericality: { greater_than: 0 }
  validates :threshold, presence: true, numericality: { greater_than: 0 }
end
