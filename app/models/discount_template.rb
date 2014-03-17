class DiscountTemplate < ActiveRecord::Base
	def replicate(pass_id)
		Discount.create(:pass_id => pass_id, :mode_id => self.mode_id, :markdown => self.markdown, :constant => self.constant)
	end
end