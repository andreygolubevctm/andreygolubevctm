package com.ctm.web.life.model.request;

import javax.validation.Valid;

public class LifeRequest {
	
	@Valid
	private Primary primary;
	
	@Valid
	private LifePerson partner;

	private ContactDetails contactDetails;

	private LifeRequest(Builder builder) {
		primary = builder.primary;
		partner = builder.partner;
		contactDetails = builder.contactDetails;
	}

	public LifePerson getPartner() {
		return partner;
	}

	public Primary getPrimary() {
		return primary;
	}

	public ContactDetails getContactDetails() {
		return contactDetails;
	}


	public static final class Builder {
		private Primary primary;
		private LifePerson partner;
		private ContactDetails contactDetails;

		public Builder() {
		}

		public Builder primary(Primary val) {
			primary = val;
			return this;
		}

		public Builder partner(LifePerson val) {
			partner = val;
			return this;
		}

		public Builder contactDetails(ContactDetails val) {
			contactDetails = val;
			return this;
		}

		public LifeRequest build() {
			return new LifeRequest(this);
		}
	}
}
