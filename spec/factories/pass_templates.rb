require 'faker'

FactoryGirl.define do
	factory :pass_template do |p|
		p.membership_required false
		p.payment_required true
		p.price 25.0
		p.term 1
		p.term_unit "months"
	end
end