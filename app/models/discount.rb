class Discount < ActiveRecord::Base
	# Stores information on potential discounts for modes of transit.
	belongs_to :mode
	belongs_to :pass
	def price
		return (self.mode.price.to_f * self.markdown.to_f + self.constant.to_f)
	end

	def max_increment
		return (self.mode.get_max_increment.to_f * self.markdown.to_f)
	end

end