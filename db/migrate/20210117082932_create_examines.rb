class CreateExamines < ActiveRecord::Migration
  def change
    create_table :examines do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    
      t.text :hierarchy
    

    

    
      t.references :user
    

      t.timestamps null: false
    end
  end
end
