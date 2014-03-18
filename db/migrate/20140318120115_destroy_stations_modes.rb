class DestroyStationsModes < ActiveRecord::Migration
  def change
  	drop_table :stations_modes
  end
end
