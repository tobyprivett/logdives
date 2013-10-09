class AddImageHashToDivesites < ActiveRecord::Migration
  def self.up
    add_column :dive_sites, :images_hash, :text
  end

  def self.down
    remove_column :dive_sites, :images_hash
  end
end