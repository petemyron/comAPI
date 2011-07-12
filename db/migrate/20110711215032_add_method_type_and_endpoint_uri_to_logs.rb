class AddMethodTypeAndEndpointUriToLogs < ActiveRecord::Migration
  def self.up
    add_column :logs, :method_type, :string
    add_column :logs, :endpoint_uri, :string
  end

  def self.down
    remove_column :logs, :method_type
    remove_column :logs, :endpoint_uri
  end
end
