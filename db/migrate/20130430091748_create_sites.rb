class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :pic
      t.integer :rank
      t.text :info
      t.text :intro
      t.integer :area_id
      t.integer :nation_id
      t.integer :nation_group_id

      t.timestamps
    end
    add_index :sites, :area_id
    add_index :sites, :nation_id
    add_index :sites, :nation_group_id
  end
end
