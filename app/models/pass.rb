class Pass < ActiveRecord::Base
	belongs_to :account
	has_many :discounts
end