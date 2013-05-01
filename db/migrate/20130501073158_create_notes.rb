class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.string :author
      t.integer :read_num
      t.string :date
      t.string :pic
      t.text :content, :limit => 65535*1.2
      t.integer :area_id
      t.integer :order_best
      t.integer :order_new
      t.string :link

      t.timestamps
    end

    add_index :notes, :area_id
    add_index :notes, :title
    add_index :notes, :link
  end
end
