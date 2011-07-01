class AddRecentGroupToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :recent_group_id, :integer
  end

  def self.down
    remove_column :users, :recent_group_id
  end
end
