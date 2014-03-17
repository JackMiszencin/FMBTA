require 'faker'

FactoryGirl.define do
	factory :citizen do |c|
		c.first_name {Faker::Name.first_name}
		c.last_name {Faker::Name.last_name}
		c.date_of_birth {Time.new(Random.new.rand(0..2014), Random.new.rand(1..12), Random.new.rand(1..31))}
	end
end