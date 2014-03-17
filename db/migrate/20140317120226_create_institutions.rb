class CreateInstitutions < ActiveRecord::Migration
  def change
    add_column :institutions, :ein, :string 
  end
end
