class CreateCommonParams < ActiveRecord::Migration
  def self.up
    create_table :common_params do |t|
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :common_params
  end
end
