class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.string :author
      t.integer :read_num
      t.string :date
      t.string :pic
      t.integer :area_id
      t.integer :order_best
      t.integer :order_new
      t.string :link
      t.integer :nation_id
      t.integer :nation_group_id
      t.text :content, :limit => 65535*1.2

      t.timestamps
    end

    add_index :notes, :area_id
    add_index :notes, :title
    add_index :notes, :link
    add_index :notes, :nation_id
    add_index :notes, :nation_group_id
  end
end
