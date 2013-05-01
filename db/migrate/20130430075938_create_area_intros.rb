class CreateAreaIntros < ActiveRecord::Migration
  def change
    create_table :area_intros do |t|
      t.integer :area_id
      t.text :intro
      t.string :title
      t.integer :area_intro_cate_id

      t.timestamps
    end
    add_index :area_intros, :area_id
    add_index :area_intros, :area_intro_cate_id
  end
end
