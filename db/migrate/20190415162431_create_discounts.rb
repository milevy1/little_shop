class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.boolean :active, default: false
      t.decimal :discount
      t.decimal :threshold

      t.timestamps
    end
  end
end
