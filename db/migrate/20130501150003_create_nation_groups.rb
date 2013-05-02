class CreateNationGroups < ActiveRecord::Migration
  def change
    create_table :nation_groups do |t|
      t.string :name
      t.integer :state_id

      t.timestamps
    end
  end
end
