class ChangeMembershipExpirationAnotherTime < ActiveRecord::Migration
  def change
  	remove_column :memberships, :expiration
  	add_column :memberships, :expiration, :date
  end
end
