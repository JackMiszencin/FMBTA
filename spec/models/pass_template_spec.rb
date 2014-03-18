require 'spec_helper'

describe PassTemplate, '#real_price' do
	it 'returns half price for prorated after 15th' do
		set_late_time
		setup_prorated_pass(true)
		expect(@pass_template.real_price).to eq 50.0
	end
	it 'returns full price for prorated before 15th' do
		set_early_time
		setup_prorated_pass(true)
		expect(@pass_template.real_price).to eq 100.0
	end
	it 'returns full price for non-prorated after 15th' do
		set_late_time
		setup_prorated_pass(false)
		expect(@pass_template.real_price).to eq 100.0
	end
	it 'returns full price for non-prorated before 15th' do
		set_early_time
		setup_prorated_pass(false)
		expect(@pass_template.real_price).to eq 100.0
	end
end

def set_early_time
	@time_now = Time.new(2014, 3, 13, 9, 30)
  Time.stub(:now).and_return(@time_now)
  @date_today = Date.new(2014, 3, 13)
  Date.stub(:today).and_return(@date_today)
end

def set_late_time
	@time_now = Time.new(2014, 3, 17, 9, 30)
  Time.stub(:now).and_return(@time_now)
  @date_today = Date.new(2014, 3, 17)
  Date.stub(:today).and_return(@date_today)
end

def setup_prorated_pass(prorated)
	@institution = create(:institution)
	@pass_template = create(:pass_template, :institution_id => @institution.id, :membership_required => true, :payment_required => true, :price => 100.0, :prorated => prorated)
end