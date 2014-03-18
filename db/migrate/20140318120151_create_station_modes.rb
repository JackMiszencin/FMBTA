class CreateStationModes < ActiveRecord::Migration
  def change
    create_table :station_modes do |t|
    	t.integer :station_id, :index => true
    	t.integer :mode_id, :index => true
    end
  end
end
