class CreateFileLibs < ActiveRecord::Migration
  def change
    create_table :file_libs do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.string :path,  null: false, default: Setting.systems.default_str
    
      t.string :file_type,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.references :portfolio
    

      t.timestamps null: false
    end
  end
end
