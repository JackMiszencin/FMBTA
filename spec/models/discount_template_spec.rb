describe DiscountTemplate, 'creates duplicate discounts' do
	it 'sets right markdown and constant' do
		a = create(:account)
		m = create(:mode, :base_price => 2.0)
		d = build(:discount_template, :mode_id => m.id, :markdown => 0.5, :constant => 0.0)
		p = create(:pass, :account_id => a.id)
		dis = d.replicate(p.id)
		expect(dis.markdown.to_f).to eq 0.5
	end
end