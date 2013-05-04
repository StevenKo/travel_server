class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title
      t.string :author
      t.integer :read_num
      t.string :date
      t.string :pic
      t.integer :order_best
      t.integer :order_new
      t.string :link
      t.text :content, :limit => 65535*1.2

      t.timestamps
    end

    add_index :notes, :title
    add_index :notes, :link
  end
end
