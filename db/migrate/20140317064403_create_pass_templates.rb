class CreatePassTemplates < ActiveRecord::Migration
  def change
    create_table :pass_templates do |t|
    	t.integer :institution_id
    	t.boolean :membership_required
    	t.boolean :payment_required
    	t.integer :term
    	t.string :term_unit
    	t.decimal :price, :precision => 14, :scale => 2
    end

    create_table :institutions do |t|
    	t.string :name
    end
  end
end
