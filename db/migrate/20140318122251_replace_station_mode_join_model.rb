class ReplaceStationModeJoinModel < ActiveRecord::Migration
  def change
  	drop_table :station_modes
  	create_table :stations_modes do |t|
    	t.integer :station_id, :index => true
    	t.integer :mode_id, :index => true
  	end
  end
end
