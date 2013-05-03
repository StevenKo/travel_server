class CreateBestNotes < ActiveRecord::Migration
  def change
    create_table :best_notes do |t|
      t.integer :note_id
      t.integer :order

      t.timestamps
    end
    add_index :best_notes, :note_id
    add_index :best_notes, :order
  end
end
