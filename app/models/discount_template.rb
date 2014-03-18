class DiscountTemplate < ActiveRecord::Base
	# Model holding general settings for the creation of discounts attached to passes.
	def replicate(pass_id)
		Discount.create(:pass_id => pass_id, :mode_id => self.mode_id, :markdown => self.markdown, :constant => self.constant)
	end
end