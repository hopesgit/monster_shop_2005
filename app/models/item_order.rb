class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def check_out_items
    change = self.quantity
    current_inventory = item.inventory
    item.update(inventory: (current_inventory - change))
    item.save
  end

  def return_ordered_items
    change = self.quantity
    current_inventory = item.inventory
    item.update(inventory: (current_inventory + change))
    item.save
  end
end
