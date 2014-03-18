class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
    	t.integer :mode_id
    	t.integer :station_id
    	t.boolean :entry, :default => true
    	t.timestamps
    end
  end
end
