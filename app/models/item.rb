class Item < ApplicationRecord
  belongs_to :user, foreign_key: 'merchant_id'
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items

  validates_presence_of :name, :description

  validates :price, presence: true, numericality: {
    only_integer: false,
    greater_than: 0
  }

  validates :inventory, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  before_save :generate_slug

  def best_discount(quantity)
    item_subtotal = self.price * quantity

    merchant_best_discount = self.user.discounts
      .where("threshold <= ?", item_subtotal)
      .order(discount: :desc)
      .limit(1)
      .first

    if merchant_best_discount
      merchant_best_discount
    else
      nil
    end
  end

  def to_param
    Item.find(self.id).slug
  end

  def generate_slug
    last_item = Item.last
    if last_item.nil?
      next_item_id = 1
    else
      next_item_id = last_item.id + 1
    end

    if Item.find_by(name: name)
      self.slug = name.downcase
                      .parameterize
                      .truncate(80, omission: '')
                      .concat("-#{next_item_id}") if name
    else
      self.slug = name.downcase
                      .parameterize
                      .truncate(80, omission: '')
    end
  end

  def self.popular_items(limit)
    item_popularity(limit, :desc)
  end

  def self.unpopular_items(limit)
    item_popularity(limit, :asc)
  end

  def self.item_popularity(limit, order)
    Item.joins(:order_items)
      .select('items.*, sum(quantity) as total_ordered')
      .group(:id)
      .order("total_ordered #{order}")
      .limit(limit)
  end

  def convert_datetime_to_seconds(datetime)
    days_and_hours = datetime.split(":").first
    days = days_and_hours.split.first.to_i
    hours = days_and_hours.split.last.to_i
    hours += days * 24
    hours * 60 * 60
  end

  def average_fulfillment_time
    average_time = order_items.where(fulfilled: true).pluck("avg(order_items.updated_at - order_items.created_at)").first
    return nil unless average_time
    convert_datetime_to_seconds(average_time)
  end

  def ordered?
    order_items.count > 0
  end
end
