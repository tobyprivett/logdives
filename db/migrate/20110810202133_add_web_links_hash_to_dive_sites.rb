class AddWebLinksHashToDiveSites < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :weblinks_hash, :text
  end

  def self.down
    remove_column :dive_sites, :weblinks_hash
  end
end