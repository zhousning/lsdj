class CreateExmItems < ActiveRecord::Migration
  def change
    create_table :exm_items do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.text :hierarchy
    

    

    

    
      t.references :examine
    

      t.timestamps null: false
    end
  end
end
