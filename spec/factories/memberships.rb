FactoryGirl.define do
	factory :membership do |m|
		m.expiration (Time.now + 2.years)
	end
end