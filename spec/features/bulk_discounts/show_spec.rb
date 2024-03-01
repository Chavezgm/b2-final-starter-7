require "rails_helper"

RSpec.describe "Bulk Discount show" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Merchant 1")
    @merchant2 = Merchant.create(name: "Merchant 2")
    
    # Create Bulk Discounts for Merchant 1
    @bulk_discount_merchant1_1 = BulkDiscount.create(percentage_discount: 10, quantity_threshold: 5, merchant: @merchant1)
    @bulk_discount_merchant1_2 = BulkDiscount.create(percentage_discount: 20, quantity_threshold: 10, merchant: @merchant1)
    
    # Create Bulk Discounts for Merchant 2
    @bulk_discount_merchant1_3 = BulkDiscount.create(percentage_discount: 15, quantity_threshold: 5, merchant: @merchant2)
  end

  describe 'US 5' do
    it 'Bulk Discount edit ' do
      visit merchant_bulk_discount_path(@merchant1, @bulk_discount_merchant1_1 )
      # When I visit my bulk discount show page

      expect(page).to have_link('Edit Bulk Discount')
      # Then I see a link to edit the bulk discount

      click_link('Edit Bulk Discount')
      # When I click this link

      visit edit_merchant_bulk_discount_path(@merchant1, @bulk_discount_merchant1_1)
      # Then I am taken to a new page with a form to edit the discount
      
      # save_and_open_page
      # expect(page).to have_content(@bulk_discount_merchant1_1.percentage_discount)
      # expect(page).to have_content('Quantity Threshold: 5')
      expect(page).to have_field('Percentage discount', with: '10')
      expect(page).to have_field('Quantity threshold', with: '5')

      # And I see that the discounts current attributes are pre-poluated in the form
      fill_in :percentage_discount, with: 20
      fill_in :quantity_threshold, with: 5
      click_button("Update Bulk Discount")
      # When I change any/all of the information and click submit

      expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @bulk_discount_merchant1_1))
      # Then I am redirected to the bulk discount's show page

      expect(page).to have_content('Percentage Discount: 20')
      expect(page).to have_content('Quantity Threshold: 5')
      # And I see that the discount's attributes have been updated
    end
  end
end