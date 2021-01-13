class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.float  :coin,              null: false, default: 0
      t.float  :freeze_coin,       null: false, default: 0
      t.float  :commission,        null: false, default: 0
      t.string :status,            null: false, default: Setting.accounts.disable 
      t.string :password,          null: false, default: ''
      t.string :number

      t.references :user
      t.timestamps null: false
    end
  end
end
