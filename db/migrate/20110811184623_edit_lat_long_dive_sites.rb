class EditLatLongDiveSites < ActiveRecord::Migration
  def self.up
    remove_column :dive_sites, :latlong
    add_column :dive_sites, :address, :string
  end

  def self.down
    remove_column :dive_sites, :address
  end
end