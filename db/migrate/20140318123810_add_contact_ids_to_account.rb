class AddContactIdsToAccount < ActiveRecord::Migration
  def change
  	add_column :accounts, :first_contact_id, :integer
  	add_column :accounts, :last_contact_id, :integer
  end
end
