class CreateModes < ActiveRecord::Migration
  def change
    create_table :modes do |t|
    	t.string :name
    	t.decimal :base_price, :precision => 14, :scale => 2
    end
  end
end
