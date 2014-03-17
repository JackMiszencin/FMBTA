class Discount < ActiveRecord::Base
	belongs_to :mode
	belongs_to :pass
	def price
		return (self.mode.base_price.to_f * self.markdown.to_f + self.constant.to_f)
	end
end