future = (Date.today + 3.weeks)
past = (Date.today - 3.weeks)

describe Membership, "scope active" do
	it 'returns both nil expirations and future expirations' do
		m1 = create(:membership, :expiration => nil)
		m2 = create(:membership, :expiration => future)
		m3 = create(:membership, :expiration => past)
		expect(m1.expiration).to eq nil
		expect(m2.expiration).to eq future
		expect(m3.expiration).to eq past
		expect(Membership.active.include? m1).to eq true
		expect(Membership.active.include? m2).to eq true
		expect(Membership.active.include? m3).to eq false		
	end
end