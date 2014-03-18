class ChangeMembershipExpirationAgain < ActiveRecord::Migration
  def change
  	remove_column :memberships, :expiration
  	add_column :memberships, :expiration, :datetime
  end
end
