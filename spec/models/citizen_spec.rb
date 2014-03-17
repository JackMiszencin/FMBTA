require 'spec_helper'

describe Citizen, 'cannot create two with same ss_number or license_number' do
	it 'refuses to save when creating two with same ss_number' do
		ss = "111111111"
		ss2 = "111111112"
		c = create(:citizen, :ss_number => ss)
		c1 = build(:citizen, :ss_number => ss)
		c1.should_not be_valid
		c2 = build(:citizen, :ss_number => ss2)
		c2.should be_valid
	end
	it 'refuses to save when creating two with same license_number' do
		c = create(:citizen, :license_number => '111111111')
		c1 = build(:citizen, :license_number => '111111111')
		c2 = build(:citizen, :license_number => '111111112')
		c1.should_not be_valid
		c2.should be_valid
	end
end
describe Citizen, 'cannot enter invalid ss_number values' do
	it 'refuses to save with letters in ss_number' do
		c = build(:citizen, :ss_number => '11111111a')
		c.should_not be_valid
	end
	it 'refuses to save with more or less than nine characters' do
		c = build(:citizen, :ss_number => '1111111111')
		c1 = build(:citizen, :ss_number => '1111')
		c.should_not be_valid
		c1.should_not be_valid
	end
end