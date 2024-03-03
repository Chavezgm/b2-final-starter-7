class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    total = 0
    invoice_items.each do |invoice_item|
      discount = invoice_item.item.merchant.bulk_discounts
        .where('quantity_threshold <= ?', invoice_item.quantity)
        .order(percentage_discount: :desc)
        .first

      if discount 
        total += invoice_item.unit_price * invoice_item.quantity * (1 - discount.percentage_discount / 100.0)
      else 
        total += invoice_item.unit_price * invoice_item.quantity
      end
    end
    total
  end

  
end
