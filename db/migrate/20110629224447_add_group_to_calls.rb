class AddGroupToCalls < ActiveRecord::Migration
  def self.up
    add_column :calls, :group_id, :integer
  end

  def self.down
    remove_column :calls, :group_id
  end
end
