class CreateNationIntros < ActiveRecord::Migration
  
  def change
    create_table :nation_intros do |t|
      t.integer :nation_id
      t.text :intro
      t.string :title
      t.integer :area_intro_cate_id

      t.timestamps
    end
    add_index :nation_intros, :nation_id
    add_index :nation_intros, :area_intro_cate_id
  end
  
end
