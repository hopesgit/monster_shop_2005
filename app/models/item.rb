class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :image,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.top_five
    Item.joins(:item_orders).select('items.*, sum(quantity) as total_sum').group(:id).order(total_sum: :desc).limit(5)
  end

  def self.bottom_five
    Item.joins(:item_orders).select('items.*, sum(quantity) as total_sum').group(:id).order(total_sum: :asc).limit(5)
  end
end
