class ReplaceModes < ActiveRecord::Migration
  def change
  	drop_table :modes
    create_table :modes do |t|
    	t.string :name
    	t.decimal :base_price, :precision => 14, :scale => 2
    end
  end
end
