class Membership < ActiveRecord::Base
	belongs_to :citizen
	belongs_to :institution

	scope :active, where("expiration IS NULL or expiration < ?", Time.now)

	def expired?
		return (self.expiration.nil? || (Time.now > self.expiration))
	end
end