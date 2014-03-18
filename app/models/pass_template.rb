class PassTemplate < ActiveRecord::Base
	has_many :discount_templates

	def real_price
		return ((self.prorated && Date.today.day >= 15) ? (0.5 * self.price.to_f) : self.price.to_f)
	end
end