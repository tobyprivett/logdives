class AddNameToDiveSites < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :name, :string
    add_index :dive_sites, :name
  end

  def self.down
    remove_column :dive_sites, :name
  end
end
