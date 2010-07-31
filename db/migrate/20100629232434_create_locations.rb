class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :vendor_id, :null => false
      t.string :name
      t.string :location
      t.float :latitude
      t.float :longitude
      t.string :gmap_feature_url

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
