class Pass < ActiveRecord::Base
	# This model holds the discounts that can be applied to modes of transit for accounts.
	belongs_to :account
	has_many :discounts
end
