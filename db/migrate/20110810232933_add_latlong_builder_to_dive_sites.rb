class AddLatlongBuilderToDiveSites < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :latlong_builder, :string
  end

  def self.down
    remove_column :dive_sites, :latlong_builder
  end
end
