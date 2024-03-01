require "rails_helper"

RSpec.describe "Merchant Bulk Discounts Index" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Merchant 1")
    @merchant2 = Merchant.create(name: "Merchant 2")
    
    # Create Bulk Discounts for Merchant 1
    @bulk_discount_merchant1_1 = BulkDiscount.create(percentage_discount: 10, quantity_threshold: 5, merchant: @merchant1)
    @bulk_discount_merchant1_2 = BulkDiscount.create(percentage_discount: 20, quantity_threshold: 10, merchant: @merchant1)
    
    # Create Bulk Discounts for Merchant 2
    @bulk_discount_merchant1_3 = BulkDiscount.create(percentage_discount: 15, quantity_threshold: 5, merchant: @merchant2)
  end
  
  describe 'US 1' do
  it 'has a link to view all discounts ' do
    visit merchant_dashboard_index_path(@merchant1)
    # When I visit my merchant dashboard

    expect(page).to have_link('View All Discounts')
    # Then I see a link to view all my discounts

    click_link('View All Discounts')
    # When I click this link
    
    expect(current_path).to eq( merchant_bulk_discounts_path(@merchant1))
    # Then I am taken to my bulk discounts index page
    # save_and_open_page
    expect(page).to have_content('Merchant Discounts:')
    expect(page).to have_content('Percentage Discount: 10 Quantity Threshold: 5')
    expect(page).to have_content('Percentage Discount: 20 Quantity Threshold: 10')
    # Where I see all of my bulk discounts including their
    # percentage discount and quantity thresholds
    
    expect(page).to_not have_content('Percentage Discount: 15 Quantity Threshold: 5')
    
    expect(page).to have_link('Details', href: merchant_bulk_discount_path(@merchant1, @bulk_discount_merchant1_1))
    expect(page).to have_link('Details', href: merchant_bulk_discount_path(@merchant1, @bulk_discount_merchant1_2))
    # And each bulk discount listed includes a link to its show page
    end
  end
end