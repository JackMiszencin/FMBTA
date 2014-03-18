class Mode < ActiveRecord::Base

	def price
		if ["6", "7"].include? Time.now.strftime("%u")
			return (0.75 * self.base_price.to_f)
		else
			return self.base_price
		end
	end
end