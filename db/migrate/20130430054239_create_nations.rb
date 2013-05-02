class CreateNations < ActiveRecord::Migration
  def change
    create_table :nations do |t|
      t.string :name
      t.string :name_cn
      t.string :link
      t.integer :state_id
      t.integer :nation_group_id

      t.timestamps
    end
    add_index :nations, :state_id
    add_index :nations, :link
    add_index :nations, :nation_group_id
  end
end
