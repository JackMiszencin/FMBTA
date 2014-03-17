class AddDateOfBirthToCitizen < ActiveRecord::Migration
  def change
  	add_column :citizens, :date_of_birth, :time
  end
end
