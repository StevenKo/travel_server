class AddPicsToSites < ActiveRecord::Migration
  def change
    add_column :sites, :pics, :text
  end
end
