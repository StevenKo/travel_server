class CreateAreaIntroCates < ActiveRecord::Migration
  def change
    create_table :area_intro_cates do |t|
      t.string :name

      t.timestamps
    end
  end
end
