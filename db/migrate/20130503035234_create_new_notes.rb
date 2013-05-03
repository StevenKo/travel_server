class CreateNewNotes < ActiveRecord::Migration
  def change
    create_table :new_notes do |t|
      t.integer :note_id
      t.integer :order

      t.timestamps
    end
    add_index :new_notes, :note_id
    add_index :new_notes, :order
  end
end
