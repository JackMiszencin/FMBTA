class Mode < ActiveRecord::Base
	has_and_belongs_to_many :stations

	def price
		if ["6", "7"].include? Time.now.strftime("%u")
			return (0.75 * self.base_price.to_f)
		else
			return self.base_price
		end
	end

	def get_max_increment
		if ["6", "7"].include? Time.now.strftime("%u")
			return (0.75 * self.max_increment.to_f)
		else
			return self.max_increment
		end
	end

	def get_increment(station_1, station_2)
		return 1.0
	end
end