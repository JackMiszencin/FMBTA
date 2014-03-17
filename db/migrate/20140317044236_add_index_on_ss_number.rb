class AddIndexOnSsNumber < ActiveRecord::Migration
  def change
  	add_index :citizens, :ss_number
  end
end
