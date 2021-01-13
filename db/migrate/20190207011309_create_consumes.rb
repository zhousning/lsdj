class CreateConsumes < ActiveRecord::Migration
  def change
    create_table :consumes do |t|
      t.string :number
      t.string :category, null: false, default: "none"
      t.float :coin_cost, null: false, default: 0
      t.float :coin_now
      t.string :status, null: false, default: "none"

      t.references :user
      t.references :demand
      t.references :trade_order
      t.references :citrine
      t.timestamps null: false
    end
  end
end
