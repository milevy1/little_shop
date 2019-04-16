require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe "Checking out with a bulk discount" do
  before :each do
    @merchant_1 = create(:merchant)
    @discount_1 = @merchant_1.discounts.create(name: "An arbitrary value", discount: 15, threshold: 30)
    @item_1 = create(:item, user: @merchant_1, inventory: 3, price: 10)

    @merchant_2 = create(:merchant)
    @item_2 = create(:item, user: @merchant_2, price: 1)

    visit item_path(@item_1)
    click_on "Add to Cart"
    visit item_path(@item_1)
    click_on "Add to Cart"
    visit item_path(@item_1)  # Cart has 3x quantity of @item_1 ($30)
    click_on "Add to Cart"
    visit item_path(@item_2)  # Cart has 1x quantity of @item_2
    click_on "Add to Cart"
  end

  it "updates the cart total to include the discount" do
    total = @item_1.price * 3 - @discount_1.discount + @item_2.price

    expect(page).to have_content("Total: $#{total}")
  end

  it "shows the discount details next to the item it applied to" do
    expected = "Discount: -#{number_to_currency @discount_1.discount} (#{number_to_currency @discount_1.discount} off order of #{number_to_currency @discount_1.threshold} or more)"

    within "#item-#{@item_1.id}" do
      expect(page).to have_content(expected)
    end
  end

  it "updates the item subtotal to include the discount" do
    expected_subtotal = @item_1.price * 3 - @discount_1.discount

    within "#item-#{@item_1.id}" do
      expect(page).to have_content("subtotal: #{number_to_currency expected_subtotal}")
    end
  end

  scenario 'checking out as a user will use the discount in the order_items.price' do
    user = create(:user)
    login_as(user)
    visit cart_path
    click_on "Check Out"

    order = Order.last
    expected_subtotal = @item_1.price * 3 - @discount_1.discount + @item_2.price

    expect(current_path).to eq(profile_orders_path)

    within "#order-#{order.id}" do
      expect(page).to have_content("Total Cost: #{number_to_currency expected_subtotal}")
    end
  end
end
