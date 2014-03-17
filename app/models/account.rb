class Account < ActiveRecord::Base
	belongs_to :citizen
	has_many :passes
	has_many :discounts, :through => :passes

	def assign_citizen_by_ss(ss_number)
		c = Citizen.find_by_ss(ss_number)
		self.update_attributes(:citizen_id => c.id)
	end

	def add_value(amount, cc, cvc)
		return self.update_attributes(:value => (self.value.to_f + amount.to_f)) if Merchant.purchase(amount, cc, cvc)
		return false
	end

	def get_pass(pass_template, cc, cvc, ss_number=nil)
		if pass_template.institution_id.present? && pass_template.membership_required
			return false unless self.check_membership(pass_template.institution_id, ss_number)
		end
		if pass_template.payment_required
			return false unless Merchant.purchase(pass_template.price, cc, cvc)
		end
		pass = self.passes.create
		pass_template.discount_templates.each do |dt|
			dt.replicate(pass.id)
		end
	end

	def get_mode_price(mode)
		(self.discounts.where(:mode_id => mode.id).collect{|x| x.price} + [mode.base_price]).min.to_f
	end
end
