class AddProratedToPassTemplate < ActiveRecord::Migration
  def change
  	add_column :pass_templates, :prorated, :boolean, :default => false
  end
end
