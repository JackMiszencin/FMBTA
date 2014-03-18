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

	def check_membership(institution_id, ss_number)
		citizen = Citizen.find_by_ss(ss_number)
		return false unless citizen
		return false unless self.update_attributes(:citizen_id => citizen.id)
		membership = Membership.active.where(:institution_id => institution_id).where(:citizen_id => citizen.id).first
		return !membership.nil?		
	end

	def get_pass(pass_template, cc, cvc, ss_number=nil)
		if pass_template.institution_id.present? && pass_template.membership_required
			return false unless self.check_membership(pass_template.institution_id, ss_number)
		end
		unless pass_template.min_age.nil?
			return false unless (self.citizen.date_of_birth <= (Date.today - pass_template.min_age.years))
		end
		unless pass_template.max_age.nil?
			return false unless (self.citizen.date_of_birth >= (Date.today - pass_template.max_age.years))
		end
		if pass_template.payment_required
			return false unless Merchant.purchase(pass_template.price, cc, cvc)
		end
		pass = self.passes.create
		pass_template.discount_templates.each do |dt|
			dt.replicate(pass.id)
		end
		return true
	end

	def get_mode_price(mode)
		(self.discounts.where(:mode_id => mode.id).collect{|x| x.price} + [mode.price]).min.to_f
	end

	def pay_fare(mode)
		price = get_mode_price(mode)
		return false unless self.value.to_f >= price.to_f
		return self.update_attributes(:value => (self.value.to_f - price.to_f))
	end

end
