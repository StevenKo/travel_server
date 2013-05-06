class AddNameCnToNationGroup < ActiveRecord::Migration
  def change
    add_column :nation_groups, :name_cn , :string 
  end
end
