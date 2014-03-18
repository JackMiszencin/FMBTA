require 'spec_helper'



describe Account, 'relational methods work' do
	before(:each) do
		set_constants
	end

	it 'assigns citizen correctly' do
		create_citizens
		@account = create(:account)
		@account.citizen = @citizen1
		@account.save
		expect(@account.citizen.first_name).to eq 'Bobby'
	end
	it 'assigns correct citizen with assign_citizen_by_ss' do
		create_citizens
		@account = create(:account)
		@account.assign_citizen_by_ss(@ss_number1)
		expect(@account.citizen.first_name).to eq 'Bobby'
	end
end

describe Account, '#add_value' do
	before(:each) do
		set_constants
	end
	it 'adds value with nil initial value' do
		intitialize_and_add_to_account(nil, 25.0)
		expect(@account.value).to eq 25.0
	end
	it 'adds value with real initial value' do
		intitialize_and_add_to_account(25.0, 10.0)
		expect(@account.value).to eq 35.0
	end
end

describe Account, '#get_pass' do
	before(:each) do
		set_constants
	end

	it 'retrieves pass given pass_template_id and standard account' do
		setup_pass(false, false, true, 0.5, 0.0, 2.0)
		buy_and_check_pass(nil, true, 1)
		expect_prices(0.5, 0.0, 1.0)
	end

	it 'retrieves membership_required pass for citizen with correct id' do
		setup_pass(true, true, false, 0.5, 0.5, 2.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect_prices(0.5, 0.5, 1.5)
	end

	it 'does not retrieve membership_required pass for citizen without correct id' do
		setup_pass(true, true, false, 0.5, 0.5, 2.0)
		buy_and_check_pass(@ss_number2, false, 0)
	end

	it 'buys a pass requiring both membership and purchase' do
		setup_pass(true, true, true, 0.5, 0.7, 2.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect_prices(0.5, 0.7, 1.7)
	end

	it 'retrieves pass with min_age restriction' do
		set_age_constraints(56, 55, nil)
		set_age_mode_discount(0.5, 0.7, 2.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect_prices(0.5, 0.7, 1.7)	
	end

	it 'denies pass with min_age restriction' do
		set_age_constraints(54, 55, nil)
		set_age_mode_discount(0.5, 0.7, 2.0)
		buy_and_check_pass(@ss_number1, false, 0)
		expect_prices(nil, nil, 2.0)		
	end

	it 'retrieves pass with max_age restriction' do
		set_age_constraints(17, nil, 18)
		set_age_mode_discount(0.5, 0.7, 2.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect_prices(0.5, 0.7, 1.7)		
	end

	it 'denies pass with max_age restriction' do
		set_age_constraints(19, nil, 18)
		set_age_mode_discount(0.5, 0.7, 2.0)
		buy_and_check_pass(@ss_number1, false, 0)
		expect_prices(nil, nil, 2.0)		
	end

end

describe Account, "#pay_fare during week" do
	before(:each) do
		set_constants
		set_week_time
	end

	it 'pays fare without discount' do
		intitialize_and_add_to_account(0.0, 25.0)
		@mode = create(:mode, :base_price => 2.0)
		expect(@account.pay_fare(@mode)).to eq true
		expect(@account.value).to eq 23.0
	end

	it 'pays zero fare from empty account' do
		setup_pass(true, true, false, 0.0, 0.0, 2.0)
		intitialize_and_add_to_account(0.0, 0.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect(@account.pay_fare(@mode)).to eq true
		expect(@account.value).to eq 0.0		
	end

	it 'pays fare with discount' do
		setup_pass(true, true, false, 0.5, 0.7, 2.0)
		intitialize_and_add_to_account(25.0, 0.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect(@account.pay_fare(@mode)).to eq true
		expect(@account.value).to eq 23.3		
	end

	it 'refuses access if not enough money on full fare' do
		intitialize_and_add_to_account(0.0, 1.5)
		@mode = create(:mode, :base_price => 2.0)
		expect(@account.pay_fare(@mode)).to eq false
		expect(@account.value).to eq 1.5
	end

	it 'refuses access if not enough money on discounted fare' do
		setup_pass(true, true, false, 0.5, 0.7, 2.0)
		intitialize_and_add_to_account(1.0, 0.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect(@account.pay_fare(@mode)).to eq false
		expect(@account.value).to eq 1.0		
	end

end

describe Account, "#pay_fare during weekend" do
	before(:each) do
		set_constants
		set_weekend_time
	end

	it 'pays fare without discount' do
		intitialize_and_add_to_account(0.0, 25.0)
		@mode = create(:mode, :base_price => 2.0)
		expect(@account.pay_fare(@mode)).to eq true
		expect(@account.value).to eq 23.5
	end

	it 'pays zero fare from empty account' do
		setup_pass(true, true, false, 0.0, 0.0, 2.0)
		intitialize_and_add_to_account(0.0, 0.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect(@account.pay_fare(@mode)).to eq true
		expect(@account.value).to eq 0.0		
	end

	it 'pays fare with discount' do
		setup_pass(true, true, false, 0.5, 0.5, 2.0)
		intitialize_and_add_to_account(25.0, 0.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect(@account.pay_fare(@mode)).to eq true
		expect(@account.value).to eq 23.75		
	end

	it 'refuses access if not enough money on full fare' do
		intitialize_and_add_to_account(0.0, 1.0)
		@mode = create(:mode, :base_price => 2.0)
		expect(@account.pay_fare(@mode)).to eq false
		expect(@account.value).to eq 1.0
	end

	it 'refuses access if not enough money on discounted fare' do
		setup_pass(true, true, false, 0.5, 0.5, 2.0)
		intitialize_and_add_to_account(1.0, 0.0)
		buy_and_check_pass(@ss_number1, true, 1)
		expect(@account.pay_fare(@mode)).to eq false
		expect(@account.value).to eq 1.0		
	end

end

def intitialize_and_add_to_account(initial, added)
	@account = create(:account, :value => initial)
	@account.add_value(added, @fake_cc, @fake_cvc)
end

def buy_and_check_pass(ss_number, success, pass_count)
	expect(@account.get_pass(@pass_template, @fake_cc, @fake_cvc, ss_number)).to eq success
	expect(@account.passes.count).to eq pass_count
	expect(@account.discounts.length).to eq pass_count
end

def expect_prices(markdown, constant, price)
	if markdown.nil? && constant.nil?
		expect(@account.discounts.length).to eq 0
	else
		expect(@account.discounts.last.markdown.to_f).to eq markdown
		expect(@account.discounts.last.constant.to_f).to eq constant
	end
	expect(@account.get_mode_price(@mode).to_f).to eq price
end

def set_constants
	@fake_cc = '1111222233334444'
	@fake_cvc = '123'
	@ss_number1 = '123456789'
	@ss_number2 = '111111111'
end

def set_week_time
	@time_now = Time.new(2014, 3, 17, 9, 30)
  Time.stub(:now).and_return(@time_now)
  @date_today = Date.new(2014, 3, 17)
  Date.stub(:today).and_return(@date_today)
end

def set_weekend_time
	@time_now = Time.new(2014, 3, 15, 9, 30)
  Time.stub(:now).and_return(@time_now)
  @date_today = Date.new(2014, 3, 15)
  Date.stub(:today).and_return(@date_today)
end

def set_age_constraints(citizen_age, min_age, max_age)
	@citizen1 = create(:citizen, :first_name => 'Bobby', :ss_number => @ss_number1, :date_of_birth => (Date.today - citizen_age.years))
	@account = create(:account)
	@institution = create(:institution)
	@pass_template = create(:pass_template, :institution_id => @institution.id, :membership_required => true, :payment_required => true, :price => 25.0, :min_age => min_age, :max_age => max_age)
end

def set_age_mode_discount(markdown, constant, mode_price)
	@mode = create(:mode, :base_price => mode_price)
	@membership = create(:membership, :citizen_id => @citizen1.id, :institution_id => @institution.id)
	@discount_template = create(:discount_template, :pass_template_id => @pass_template.id, :mode_id => @mode.id, :markdown => markdown, :constant => constant)
end

def create_citizens
	@citizen1 = create(:citizen, :first_name => 'Bobby', :ss_number => @ss_number1)
	@citizen2 = create(:citizen, :first_name => 'Billy', :ss_number => @ss_number2)
end

def setup_pass(set_pass_institution, membership_required, payment_required, markdown, constant, mode_price)
	create_citizens
	@account = create(:account)
	@institution = create(:institution)
	@pass_template = create(:pass_template, :institution_id => (set_pass_institution ? @institution.id : nil), :membership_required => membership_required, :payment_required => payment_required, :price => 25.0)
	@mode = create(:mode, :base_price => mode_price)
	@membership = create(:membership, :citizen_id => @citizen1.id, :institution_id => @institution.id)
	@discount_template = create(:discount_template, :pass_template_id => @pass_template.id, :mode_id => @mode.id, :markdown => markdown, :constant => constant)
end