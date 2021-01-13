class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    

    

    
      t.string :idattch
    

    

      t.timestamps null: false
    end
  end
end
