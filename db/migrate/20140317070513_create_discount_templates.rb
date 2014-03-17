class CreateDiscountTemplates < ActiveRecord::Migration
  def change
    create_table :discount_templates do |t|
    	t.integer :pass_template_id
    	t.integer :mode_id
    	t.decimal :markdown, :precision => 4, :scale => 3, :default => 1.0
    	t.decimal :constant, :precision => 4, :scale => 2, :default => 0.0
    end
  end
end
