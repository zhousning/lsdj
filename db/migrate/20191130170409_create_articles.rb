class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    
      t.string :lang,  null: false, default: Setting.systems.default_str

      t.string :title,  null: false, default: Setting.systems.default_str

      t.string :vol,  null: false, default: Setting.systems.default_str

      t.string :desc,  null: false, default: Setting.systems.default_str
    
      t.text :category
    
      t.string :address,  null: false, default: Setting.systems.default_str
    

    

      t.timestamps null: false
    end
  end
end
