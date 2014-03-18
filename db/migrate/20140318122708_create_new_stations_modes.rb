class CreateNewStationsModes < ActiveRecord::Migration
  def change
  	drop_table :stations_modes
  	create_table :modes_stations do |t|
    	t.integer :station_id, :index => true
    	t.integer :mode_id, :index => true
  	end
  end
end
