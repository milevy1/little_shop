require 'rails_helper'

RSpec.describe 'Merchants Delete functionality for their Bulk Discounts', type: :feature do
  context 'As a logged in merchant viewing my discounts index' do
    before :each do
      @merchant = create(:merchant)
      @discount_1 = @merchant.discounts.create(name: "Discount 1", discount: 10, threshold: 50)

      login_as(@merchant)
      visit dashboard_discounts_path
    end

    it 'allows me do Delete an existing discount' do
      within "#discount-#{@discount_1.id}" do
        click_link "Delete Discount"
      end

      expect(current_path).to eq(dashboard_discounts_path)

      expect(page).to_not have_content("Discount 1")
      expect(page).to_not have_content("Discount amount: $10")
      expect(page).to_not have_content("Discount threshold: $50")

    end
  end
end
