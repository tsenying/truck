class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :name,        :null => false
      t.string :location
      t.string :url
      t.string :description
      t.integer :following
      t.integer :followers
      t.integer :listed
      t.integer :tweets

      t.timestamps
    end
  end

  def self.down
    drop_table :vendors
  end
end
