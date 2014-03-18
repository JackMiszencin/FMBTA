class ChangeMembershipExpiration < ActiveRecord::Migration
  def change
  	remove_column :memberships, :expiration
  	add_column :memberships, :expiration, :timestamp
  end
end
