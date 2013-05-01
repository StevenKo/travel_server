class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :pic
      t.integer :rank
      t.text :info
      t.text :intro
      t.integer :area_id

      t.timestamps
    end
    add_index :sites, :area_id
  end
end
