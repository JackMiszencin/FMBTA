require 'spec_helper'

describe Mode, '#price' do
	it 'returns full fare during week' do
		@time_now = Time.new(2014, 3, 17, 9, 30)
	  Time.stub(:now).and_return(@time_now)
	  @date_today = Date.new(2014, 3, 17)
	  Date.stub(:today).and_return(@date_today)
		@mode = create(:mode, :base_price => 2.0)
		expect(@mode.price).to eq 2.0
	end

	it 'returns discounted fare during weekend' do
		@time_now = Time.new(2014, 3, 15, 9, 30)
	  Time.stub(:now).and_return(@time_now)
	  @date_today = Date.new(2014, 3, 15)
	  Date.stub(:today).and_return(@date_today)
		@mode = create(:mode, :base_price => 2.0)
		expect(@mode.price).to eq 1.5
	end
end