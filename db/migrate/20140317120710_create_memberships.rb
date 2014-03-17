class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
    	t.integer :citizen_id, :index => true
    	t.integer :institution_id, :index => true
    	t.time :expiration
    end
  end
end
