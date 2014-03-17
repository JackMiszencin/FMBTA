require 'faker'

FactoryGirl.define do
	factory :institution do |i|
		i.name Faker::Company.name
	end
end