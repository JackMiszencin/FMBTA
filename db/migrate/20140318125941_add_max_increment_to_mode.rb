class AddMaxIncrementToMode < ActiveRecord::Migration
  def change
  	add_column :modes, :max_increment, :decimal, :precision => 14, :scale => 2
  end
end
