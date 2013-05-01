class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :name_cn
      t.string :link
      t.integer :nation_id
      t.string :pic
      t.string :note_link
      t.string :site_link

      t.timestamps
    end
    add_index :areas, :nation_id
  end
end
