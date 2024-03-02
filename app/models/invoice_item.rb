class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def applied_discount(discounts)
    discounts
      .where("quantity_threshold <= ?", self.quantity)
      .pluck(:percentage_discount, :id)
      .first
  end 
  #takes a collection of bulk discounts as an argument,filters these discounts to find the one that applies to the current quantity of the invoice item
  #querying the discounts collection to find those where the quantity_threshold is less than or equal to the quantity of the item
  #plucks the id and percentage_count of the matching discount
  
  def discount_applies(discounts)
    # require 'pry'; binding.pry
    discounts
      .where("quantity_threshold <= ?", self.quantity)
      .pluck(:quantity_threshold)
      .any?
  end

  #akes a collection of bulk discounts as an argument,hecks whether any of these discounts apply to the current quantity of the invoice item If at least one such discount is found, it returns true
  #determine whether a discount applies to the item,
  #This method is used when we want to render the link for the bulk discount


end
