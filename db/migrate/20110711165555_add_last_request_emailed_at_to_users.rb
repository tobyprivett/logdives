class AddLastRequestEmailedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_request_emailed_at, :datetime
  end

  def self.down
    remove_column :users, :column_name
  end
end