require 'rails_helper'

RSpec.describe 'Merchants Edit/Update functionality for their Bulk Discounts', type: :feature do
  context 'As a logged in merchant viewing my discounts index' do
    before :each do
      @merchant = create(:merchant)
      @discount_1 = @merchant.discounts.create(name: "Discount 1", discount: 10, threshold: 50)

      login_as(@merchant)
      visit dashboard_discounts_path
    end

    it 'allows me to Edit an existing discount' do
      within "#discount-#{@discount_1.id}" do
        click_link "Edit Discount"
      end

      expect(current_path).to eq(edit_dashboard_discount_path(@discount_1))

      updated_name = "Updated Discount 1"
      updated_discount = 2
      updated_threshold = 10

      fill_in "discount[name]", with: updated_name
      fill_in "discount[discount]", with: updated_discount
      fill_in "discount[threshold]", with: updated_threshold

      click_button "Save Changes"

      expect(current_path).to eq(dashboard_discounts_path)

      within "#discount-#{@discount_1.id}" do
        expect(page).to_not have_content("Discount amount: $10")
        expect(page).to_not have_content("Discount threshold: $50")

        expect(page).to have_content(updated_name)
        expect(page).to have_content("Discount amount: $#{updated_discount}")
        expect(page).to have_content("Discount threshold: $#{updated_threshold}")
      end
    end

    it 'shows me error messages if I enter invalid changes' do
      within "#discount-#{@discount_1.id}" do
        click_link "Edit Discount"
      end

      updated_discount = 50

      fill_in "discount[discount]", with: updated_discount

      click_button "Save Changes"

      expect(page).to have_content "Invalid threshold - Threshold value must be greater than the discount value."
    end
  end
end
