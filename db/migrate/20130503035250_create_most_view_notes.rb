class CreateMostViewNotes < ActiveRecord::Migration
  def change
    create_table :most_view_notes do |t|
      t.integer :note_id
      t.integer :order

      t.timestamps
    end
    add_index :most_view_notes, :note_id
    add_index :most_view_notes, :order
  end
end
