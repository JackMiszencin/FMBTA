require 'spec_helper'


fake_cc = '1111222233334444'
fake_cvc = '123'
ss_number1 = '123456789'
ss_number2 = '111111111'

describe Account, 'relational methods work' do
	it 'assigns citizen correctly' do
		c = create(:citizen, :first_name => 'Bobby')
		a = create(:account)
		a.citizen = c
		a.save
		expect(a.citizen.first_name).to eq 'Bobby'
	end
	it 'assigns correct citizen with assign_citizen_by_ss' do
		correct = ss_number1
		wrong = ss_number2
		c = create(:citizen, :first_name => 'Bobby', :ss_number => correct)
		c1 = create(:citizen, :first_name => 'Billy', :ss_number => wrong)
		a = create(:account)
		a.assign_citizen_by_ss(correct)
		expect(a.citizen.first_name).to eq 'Bobby'
	end
end
describe Account, '#add_value' do
	it 'adds value with nil initial value' do
		a = create(:account, :value => nil)
		a.add_value(25.0, fake_cc, fake_cvc)
		expect(a.value).to eq 25.0
	end
	it 'adds value with real initial value' do
		a = create(:account, :value => 25.0)
		a.add_value(10.0, fake_cc, fake_cvc)
		expect(a.value).to eq 35.0
	end
end
describe Account, '#get_pass' do
	it 'retrieves pass given pass_template_id and standard account' do
		a = create(:account, :value => 50.0)
		p = create(:pass_template, :institution_id => nil, :membership_required => false, :payment_required => true, :price => 25.0)
		m = create(:mode, :name => "subway", :base_price => 2.0)
		d = create(:discount_template, :pass_template_id => p.id, :mode_id => m.id, :markdown => 0.5, :constant => 0.0)
		a.get_pass(p, fake_cc, fake_cvc)
		expect(p.discount_templates.length).to eq 1
		expect(a.discounts.length).to eq 1
		expect(a.discounts.last.markdown).to eq 0.5
		expect(a.get_mode_price(m)).to eq 1.0
	end

	it 'retrieves membership_required pass for citizen with correct id' do
		c1 = create(:citizen, :ss_number => ss_number1)
		c1 = create(:citizen, :ss_number => ss_number2)
		i = create(:institution, :name => "Central School")
		p = create(:institution_id => id.id, :membership_required => true, :payment_required => false)
		me = create(:membership, :ss_number => ss_number1, :institution_id => i.id)
		a = create(:account)
		expect(a.get_pass(p, fake_cc, fake_cvc, ss_number1)).to eq true
		expect(a.get_pass(p, fake_cc, fake_cvc, ss_number2)).to eq false
	end

	it 'does not retrieve membership_required pass for citizen without correct id' do

	end
end