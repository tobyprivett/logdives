class AddDescriptionToDives < ActiveRecord::Migration
  def self.up
    add_column :dives, :description, :string
  end

  def self.down
    remove_column :dives, :description
  end
end
