class AddLatlongToDiveSites < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :latlong, :string
  end

  def self.down
    remove_column :dive_sites, :latlong
  end
end