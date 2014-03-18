class Contact < ActiveRecord::Base
	belongs_to :mode
	belongs_to :station

	def checkin?
		return entry
	end

	def checkout
		return !entry
	end
end