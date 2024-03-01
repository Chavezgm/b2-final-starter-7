class BulkDiscountsController < ApplicationController

  def index 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts.all
  end

  def show 
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create 
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if @bulk_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
      flash[:alert] = 'Bulk discount created'
    else
      redirect_to new_merchant_bulk_discount_path(@merchant) #???
    end

  end

  private 

  def bulk_discount_params
    params.permit(:percentage_discount, :quantity_threshold)
  end
end