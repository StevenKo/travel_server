class CreateCitiAndCityGroupRelations < ActiveRecord::Migration
  def change
    create_table :citi_and_city_group_relations do |t|
      t.integer :area_id
      t.integer :city_group_id

      t.timestamps
    end
    add_index :citi_and_city_group_relations, :city_group_id
    add_index :citi_and_city_group_relations, :area_id
  end
end
