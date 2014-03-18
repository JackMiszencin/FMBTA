class Contact < ActiveRecord::Base
	# A contact tracks the time, the mode of transit, the station, and whether the card
	# tap was to enter or leave the transit system 
	belongs_to :mode
	belongs_to :station

	def checkin?
		return entry
	end

	def checkout
		return !entry
	end
end