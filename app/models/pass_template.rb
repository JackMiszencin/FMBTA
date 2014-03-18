class PassTemplate < ActiveRecord::Base
	# Owned by an institution typically, with database fields determining selection criteria
	# for who can receive a pass. A pass itself is formed from this model.
	has_many :discount_templates

	def real_price
		return ((self.prorated && Date.today.day >= 15) ? (0.5 * self.price.to_f) : self.price.to_f)
	end
end