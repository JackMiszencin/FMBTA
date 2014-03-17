class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
    	t.integer :citizen_id
    	t.decimal :value, :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
