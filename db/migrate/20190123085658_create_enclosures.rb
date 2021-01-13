class CreateEnclosures < ActiveRecord::Migration
  def change
    create_table :enclosures do |t|
      t.timestamps null: false

      t.string :file,  null: false, default: ""

      t.references :notice
      t.references :article
      t.references :page
      t.references :format
      t.references :ocr
    end
  end
end
