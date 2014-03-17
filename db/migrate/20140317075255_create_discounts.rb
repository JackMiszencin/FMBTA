class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
    	t.integer :pass_id, :index => true
    	t.integer :mode_id, :index => true
    	t.decimal :markdown, :precision => 4, :scale => 3, :default => 1.0
    	t.decimal :constant, :precision => 4, :scale => 2, :default => 0.0
    end
  end
end
