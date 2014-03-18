class AddMinAgeMaxAgeToPassTemplate < ActiveRecord::Migration
  def change
  	add_column :pass_templates, :min_age, :integer
  	add_column :pass_templates, :max_age, :integer
  end
end
