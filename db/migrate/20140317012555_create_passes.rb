class CreatePasses < ActiveRecord::Migration
  def change
    create_table :passes do |t|
    	t.string :type
    	t.integer :account_id
      t.timestamps
    end
  end
end
