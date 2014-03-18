class AddRequireCheckoutToMode < ActiveRecord::Migration
  def change
  	add_column :modes, :require_checkout, :boolean, :default => false
  end
end
