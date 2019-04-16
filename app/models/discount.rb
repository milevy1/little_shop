class Discount < ApplicationRecord
  belongs_to :user, foreign_key: 'merchant_id'

  validates_presence_of :name

  validates :discount, presence: true, numericality: { greater_than: 0 }
  validates :threshold, presence: true, numericality: { greater_than: 0 }

  validate :threshold_larger_than_discount

  def threshold_larger_than_discount
    if self.threshold && self.discount && (self.discount >= self.threshold)
      self.errors.add(:invalid_threshold, "- Threshold value must be greater than the discount value.")
    end
  end
end
