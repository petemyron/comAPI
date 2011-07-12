class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.string :method_name
      t.text :request
      t.text :response
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end
