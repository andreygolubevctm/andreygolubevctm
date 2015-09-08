package com.ctm.model.homeloan;

import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.model.AbstractJsonModel;
import com.ctm.model.formatter.JsonUtils;
import com.ctm.model.homeloan.HomeLoanModel.CustomerSituation;

public class HomeLoanOpportunityRequest extends AbstractJsonModel {

	//private String requirementsAndObjectives;
	private String opportunityDescription;
	private String referenceId;
	private String comments;

	private HomeLoanModel model = new HomeLoanModel();
	private ArrayList<HomeLoanOpportunityProduct> products = new ArrayList<HomeLoanOpportunityProduct>();



	public String getOpportunityDescription() {
		return opportunityDescription;
	}
	public void setOpportunityDescription(String opportunityDescription) {
		this.opportunityDescription = opportunityDescription;
	}

	public String getReferenceId() {
		return referenceId;
	}
	public void setReferenceId(String referenceId) {
		this.referenceId = referenceId;
	}

	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}

	public ArrayList<HomeLoanOpportunityProduct> getProducts() {
		return products;
	}
	public void addProduct(HomeLoanOpportunityProduct product) {
		this.products.add(product);
	}

	public HomeLoanModel getModel() {
		return model;
	}
	public void setModel(HomeLoanModel model) {
		this.model = model;
	}



	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		// Add main properties

		if (model.getCustomerSituation() == CustomerSituation.FIRST_HOME_BUYER) {
			json.put("fhbFlag", "yes");
		} else {
			json.put("fhbFlag", "no");
		}

		json.put("opportunityId", Long.toString(model.getTransactionId()));
		json.put("referenceId", getReferenceId());
		json.put("ownFunds", model.getDepositAmount());
		//json.put("requirementsAndObjectives", );
		json.put("loanAmount", model.getLoanAmount());
		json.put("opportunityDescription", getOpportunityDescription());
		json.put("referenceId", getReferenceId());
		json.put("leadSource", "Compare the Market");
		json.put("state", model.getState());
		json.put("comments", getComments());

		json.put("primaryContactFirstName", model.getContactFirstName());
		json.put("primaryContactEmailAddress", model.getEmailAddress());

		String comment = "";
		if(model.getAdditionalInformation() == "OUTBOUND LEAD") {
			comment = model.getAdditionalInformation();
		} else {
			comment = "Customer has found property: " + ((model.getFoundAProperty() != null && model.getFoundAProperty() == true) ? "Y" : "N") + "; ";
			if (model.getOfferTime() != null && model.getOfferTime().length() > 0) {
				comment += "Looking to make offer: " + model.getOfferTime() + "; ";
			}
			if (model.getPropertyType() != null && model.getPropertyType().length() > 0) {
				comment += "Property type: " + model.getPropertyType() + "; ";
			}
			if (model.getEmploymentStatus() != null && model.getEmploymentStatus().length() > 0) {
				comment += "Employment status: " + model.getEmploymentStatus() + "; ";
			}
		}
		json.put("comments", comment);

		// Add products

		JsonUtils.addListToJsonObject(json, "products", getProducts());

		// Build product filter

		JSONObject productFilter = new JSONObject();
		productFilter.put("pageNum", Integer.toString(model.getPageNumber()));

		if (model.getCustomerSituation() != null) {
			productFilter.put("iAm", model.getCustomerSituation().getDescription());
		}
		if (model.getCustomerGoal() != null) {
			productFilter.put("lookingTo", model.getCustomerGoal().getDescription());
		}
		productFilter.put("state", model.getState());
		productFilter.put("amountOwingOnLoan", model.getAmountOwingOnLoan());
		productFilter.put("existingPropertiesWorth", model.getExistingPropertiesWorth());
		productFilter.put("purchasePrice", model.getPurchasePrice());
		productFilter.put("loanAmount", model.getLoanAmount());
		productFilter.put("variable", model.isRateVariable());
		productFilter.put("fixed", model.isRateFixed());
		if (model.getRepaymentOption() != null) {
			productFilter.put("repaymentOption", model.getRepaymentOption().getDescription());
		}
		productFilter.put("loanTerm", model.getLoanTerm());

		// Add product filter

		json.put("productFilter", productFilter);

		// Applicants

		JSONObject applicant = new JSONObject();
		applicant.put("applicantId", Long.toString(new Date().getTime()));
		if (model.getContactFirstName() != null && model.getContactFirstName().length() > 0) {
			applicant.put("firstName", model.getContactFirstName());
		}
		else {
			applicant.put("firstName", "UnknownFirstName");
		}
		if (model.getContactSurname() != null && model.getContactSurname().length() > 0) {
			applicant.put("lastName", model.getContactSurname());
		}
		else {
			applicant.put("lastName", "UnknownLastName");
		}
		applicant.put("email", model.getEmailAddress());
		if (model.getContactBestTime() != null) {
			switch (model.getContactBestTime()) {
			case "ANY":
				applicant.put("bestCallTime", "Anytime");
				break;
			case "M":
				applicant.put("bestCallTime", "Early morning");
				break;
			case "A":
				applicant.put("bestCallTime", "Late afternoon");
				break;
			case "E":
				applicant.put("bestCallTime", "Evening");
				break;
			}
		}
		if (model.getContactBestContact() != null) {
			switch (model.getContactBestContact()) {
			case "P":
				applicant.put("bestContact", "Phone");
				break;
			case "E":
				applicant.put("bestContact", "Email");
				break;
			}
		}
		if (model.getContactPhoneNumber() != null && model.getContactPhoneNumber().startsWith("04")) {
			applicant.put("mobilePhone", model.getContactPhoneNumber());
		}
		else {
			applicant.put("homePhone", model.getContactPhoneNumber());
		}

		comment = model.getAdditionalInformation();
		if (comment != null) {
			if (comment.length() > 255) comment = comment.substring(0, 255);
			applicant.put("comments", comment);
		}

		JSONObject address = new JSONObject();
		address.put("city", model.getAddressCity());
		address.put("postcode", model.getAddressPostcode());
		address.put("state", model.getState());

		applicant.put("address", address);

		// Add applicants

		JSONArray applicants = new JSONArray();
		applicants.put(applicant);
		json.put("applicants", applicants);



		return json;
	}

	@Override
	public String toString() {
		return "HomeLoanOpportunityRequest{" +
				"opportunityDescription='" + opportunityDescription + '\'' +
				", referenceId='" + referenceId + '\'' +
				", comments='" + comments + '\'' +
				", model=" + model +
				", products=" + products +
				'}';
	}
}
