class CreateAbordHotNotes < ActiveRecord::Migration
  def change
    create_table :abord_hot_notes do |t|
      t.integer :note_id
      t.integer :order

      t.timestamps
    end
    add_index :abord_hot_notes, :note_id
    add_index :abord_hot_notes, :order
  end
end
