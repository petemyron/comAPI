class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :method_name
      t.string :endpoint_uri
      t.text :xml

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
