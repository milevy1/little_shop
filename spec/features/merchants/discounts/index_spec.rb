require 'rails_helper'

RSpec.describe 'Merchants Bulk Discounts index page', type: :feature do
  context 'As a logged in merchant viewing my Bulk Discount index page' do
    before :each do
      @merchant = create(:merchant)
      @discount_1 = @merchant.discounts.create(name: "Discount 1", discount: 10, threshold: 50)
      @discount_2 = @merchant.discounts.create(name: "Discount 2", discount: 1, threshold: 20)

      login_as(@merchant)
      visit dashboard_path
      click_link "Bulk Discounts"
    end

    it 'shows all my bulk discounts and their info' do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content(@discount_1.name)
        expect(page).to have_content("Discount amount: $#{@discount_1.discount}")
        expect(page).to have_content("Discount threshold: $#{@discount_1.threshold}")
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content(@discount_2.name)
        expect(page).to have_content("Discount amount: $#{@discount_2.discount}")
        expect(page).to have_content("Discount threshold: $#{@discount_2.threshold}")
      end
    end

    it 'shows a link to Add Discount' do
      expect(page).to have_link("Add Discount", href: new_dashboard_discount_path)
    end

    it 'shows a link to edit discounts' do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link "Edit Discount"
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_link "Edit Discount"
      end
    end

    it 'shows a link to delete discounts' do
      within "#discount-#{@discount_1.id}" do
        expect(page).to have_link "Delete Discount"
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_link "Delete Discount"
      end
    end
  end
end
