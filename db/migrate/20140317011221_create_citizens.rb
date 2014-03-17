class CreateCitizens < ActiveRecord::Migration
  def change
    create_table :citizens do |t|
    	t.string :ss_number
    	t.string :license_number
    	t.string :first_name
    	t.string :last_name
      t.timestamps
    end
  end
end
