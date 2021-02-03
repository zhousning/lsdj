class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.string :xtitle,  null: false, default: Setting.systems.default_str
    
      t.string :ytitle,  null: false, default: Setting.systems.default_str
    
      t.string :legend,  null: false, default: Setting.systems.default_str
    
      t.text :data
    

    

    

    
      t.references :user
    

      t.timestamps null: false
    end
  end
end
