class CreateNations < ActiveRecord::Migration
  def change
    create_table :nations do |t|
      t.string :name
      t.string :name_cn
      t.string :link
      t.integer :state_id

      t.timestamps
    end
    add_index :nations, :state_id
  end
end
