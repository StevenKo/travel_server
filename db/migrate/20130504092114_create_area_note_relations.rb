class CreateAreaNoteRelations < ActiveRecord::Migration
  def change
    create_table :area_note_relations do |t|
      t.integer :note_id
      t.integer :area_id
      t.integer :nation_id
      t.integer :nation_group_id

      t.timestamps
    end
    add_index :area_note_relations, :note_id
    add_index :area_note_relations, :area_id
    add_index :area_note_relations, :nation_id
    add_index :area_note_relations, :nation_group_id
  end
end
