class Citizen < ActiveRecord::Base
	validates :license_number, :uniqueness => true, :unless => lambda{|c| c.license_number.nil?}
	validates :ss_number, :uniqueness => true, :unless => lambda{|c| c.ss_number.nil?}
	validates_format_of :ss_number, :with => /\A[0-9]{9}\z/, :allow_nil => true
	has_many :accounts

	def self.find_by_ss(number)
		Citizen.where(:ss_number => number).first
	end
end
