class ChangeDateOfBirth < ActiveRecord::Migration
  def change
  	remove_column :citizens, :date_of_birth
  	add_column :citizens, :date_of_birth, :date
  end
end
