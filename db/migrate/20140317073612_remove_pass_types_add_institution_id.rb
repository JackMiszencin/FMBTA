class RemovePassTypesAddInstitutionId < ActiveRecord::Migration
  def change
  	remove_column :passes, :type
  	add_column :passes, :insitution_id, :integer
  end
end
