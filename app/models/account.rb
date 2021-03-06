class Account < ActiveRecord::Base
	belongs_to :citizen
	has_many :passes
	has_many :discounts, :through => :passes
	# Contacts are used for keeping track of taps into and out of transit modes.
	belongs_to :first_contact, :class_name => "Contact"
	belongs_to :last_contact, :class_name => "Contact"

	def assign_citizen_by_ss(ss_number)
		c = Citizen.find_by_ss(ss_number)
		self.update_attributes(:citizen_id => c.id)
	end

	def add_value(amount, cc, cvc)
		return self.update_attributes(:value => (self.value.to_f + amount.to_f)) if Merchant.purchase(amount, cc, cvc)
		return false
	end

	def check_membership(institution_id, ss_number)
		citizen = Citizen.find_by_ss(ss_number)
		return false unless citizen
		return false unless self.update_attributes(:citizen_id => citizen.id)
		membership = Membership.active.where(:institution_id => institution_id).where(:citizen_id => citizen.id).first
		return !membership.nil?		
	end

	def get_pass(pass_template, cc, cvc, ss_number=nil)
		if pass_template.institution_id.present? && pass_template.membership_required
			return false unless self.check_membership(pass_template.institution_id, ss_number)
		end
		unless pass_template.min_age.nil?
			return false unless (self.citizen.date_of_birth <= (Date.today - pass_template.min_age.years))
		end
		unless pass_template.max_age.nil?
			return false unless (self.citizen.date_of_birth >= (Date.today - pass_template.max_age.years))
		end
		if pass_template.payment_required
			return false unless Merchant.purchase(pass_template.real_price, cc, cvc)
		end
		pass = self.passes.create
		pass_template.discount_templates.each do |dt|
			dt.replicate(pass.id)
		end
		return true
	end

	def get_mode_price(mode)
		(self.discounts.where(:mode_id => mode.id).collect{|x| x.price} + [mode.price]).min.to_f
	end

	def get_max_increment(mode)
		(self.discounts.where(:mode_id => mode.id).collect{|x| x.max_increment} + [mode.get_max_increment]).min.to_f
	end

	def pay_fare(mode)
		price = get_mode_price(mode)
		return false unless self.value.to_f >= price.to_f
		return self.update_attributes(:value => (self.value.to_f - price.to_f))
	end

	def checkin(mode, station) # Tapping a card as one enters a station or bus
		if self.last_contact.nil? && self.first_contact && self.first_contact.mode.require_checkout
			return false unless self.pay_max_increment(mode)
		end
		return false unless self.pay_fare(mode)
		self.set_first_contact(mode, station)
	end

	def checkout(mode, station) # Tapping a card as one leaves a station or bus.
		# Not all modes of transport require a checkout. For these, a single flat rate is paid
		# instead of one with increments for further station stops.
		if self.first_contact && self.first_contact.station
			return false unless pay_increment(mode, self.first_contact.station, station)
		else
			return false unless pay_max_increment(mode)
		end
		return set_last_contact(mode, station)
	end

	def set_last_contact(mode, station)
		c1 = Contact.create(:mode_id => mode.id, :station_id => station.id, :entry => false)
		self.update_attributes(:last_contact_id => c1.id)
	end

	def set_first_contact(mode, station)
		c1 = Contact.create(:mode_id => mode.id, :station_id => station.id, :entry => true)
		self.update_attributes(:first_contact_id => c1.id)
		c2 = self.last_contact
		c2.destroy if c2
		self.update_attributes(:last_contact_id => nil)
	end

	def pay_max_increment(mode)
		price = get_max_increment(mode)
		return false unless self.value.to_f >= price.to_f
		return self.update_attributes(:value => (self.value.to_f - price.to_f))
	end

	def pay_increment(mode, station1, station2)
		price = mode.get_increment(station1, station2)
		return false unless self.value.to_f >= price.to_f
		return self.update_attributes(:value => (self.value.to_f - price.to_f))
	end
end
