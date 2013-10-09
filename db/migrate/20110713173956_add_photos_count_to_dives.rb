class AddPhotosCountToDives < ActiveRecord::Migration
  def self.up
    add_column :dives, :photos_count, :integer, :default => 0
  end

  def self.down
    remove_column :dives, :photos_count
  end
end