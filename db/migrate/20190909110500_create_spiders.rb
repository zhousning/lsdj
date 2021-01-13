class CreateSpiders < ActiveRecord::Migration
  def change
    create_table :spiders do |t|
    
      t.string :link,  null: false, default: Setting.systems.default_str

      t.boolean :doc_save,  null: false, default: Setting.systems.default_boolean

      t.boolean :doc_parse,  null: false, default: Setting.systems.default_boolean

      t.text :header
    
      t.string :cookie,  null: false, default: Setting.systems.default_str
    
      t.string :agent,  null: false, default: Setting.systems.default_str
    
      t.string :content_type,  null: false, default: Setting.systems.default_str
    
      t.string :page,  null: false, default: Setting.systems.default_str
    
      t.string :file,  null: false, default: Setting.systems.default_str
    
      t.string :referer,  null: false, default: Setting.systems.default_str
    
      t.string :host,  null: false, default: Setting.systems.default_str
    
      t.string :redirection,  null: false, default: Setting.systems.default_str
    

    

      t.timestamps null: false
    end
  end
end
