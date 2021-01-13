class CreateOcrs < ActiveRecord::Migration
  def change
    create_table :ocrs do |t|
    
      t.integer :ocr_type,  null: false, default: 0 

      t.timestamps null: false
    end
  end
end
