class AddTypeToCall < ActiveRecord::Migration
  def self.up
    add_column :calls, :method_type, :string, :default => "post"
  end

  def self.down
    remove_column :calls, :type
  end
end
