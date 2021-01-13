class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.string :cn_name
      t.string :nest
      t.boolean :image
      t.boolean :attachment
      t.string :one_image
      t.string :one_attachment
      t.boolean :index
      t.boolean :new
      t.boolean :edit
      t.boolean :show
      t.boolean :form
      t.boolean :js
      t.boolean :scss
      t.boolean :admin

      t.timestamps null: false
    end
  end
end
