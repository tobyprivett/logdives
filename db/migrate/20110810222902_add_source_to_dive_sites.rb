class AddSourceToDiveSites < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :source, :string
  end

  def self.down
    remove_column :dive_sites, :source
  end
end
