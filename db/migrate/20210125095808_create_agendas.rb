class CreateAgendas < ActiveRecord::Migration
  def change
    create_table :agendas do |t|
    
      t.string :title,  null: false, default: Setting.systems.default_str
    
      t.text :content
    
      t.datetime :worktime
    

    

    
      t.string :idattch,  null: false, default: Setting.systems.default_str
    

    
      t.references :user
    

      t.timestamps null: false
    end
  end
end
