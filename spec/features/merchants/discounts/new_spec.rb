require 'rails_helper'

RSpec.describe 'Merchants create functionality for their Bulk Discounts', type: :feature do
  context 'As a logged in merchant viewing my discounts index' do
    before :each do
      @merchant = create(:merchant)
      login_as(@merchant)
      visit dashboard_discounts_path
    end

    it 'allows me to add a new discount' do
      click_link "Add Discount"

      expect(current_path).to eq(new_dashboard_discount_path)

      discount_name = "Discount name"
      discount_amount = 10
      discount_threshold = 50

      fill_in "discount[name]", with: discount_name
      fill_in "discount[discount]", with: discount_amount
      fill_in "discount[threshold]", with: discount_threshold

      click_button "Create Discount"

      expect(current_path).to eq(dashboard_discounts_path)

      expect(page).to have_content(discount_name)
      expect(page).to have_content("Discount amount: $#{discount_amount}")
      expect(page).to have_content("Discount threshold: $#{discount_threshold}")
    end
  end
end
