class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
    
      t.string :name,  null: false, default: Setting.systems.default_str
    

    

    

    
      t.references :archive
    

      t.timestamps null: false
    end
  end
end
