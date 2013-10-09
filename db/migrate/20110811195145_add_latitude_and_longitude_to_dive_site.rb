class AddLatitudeAndLongitudeToDiveSite < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :latitude, :float
    add_column :dive_sites, :longitude, :float
  end

  def self.down
    remove_column :dive_sites, :longitude
    remove_column :dive_sites, :latitude
  end
end
