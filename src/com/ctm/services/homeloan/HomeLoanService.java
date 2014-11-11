package com.ctm.services.homeloan;

import javax.servlet.http.HttpServletRequest;

import com.ctm.model.homeloan.HomeLoanModel;
import com.ctm.model.homeloan.HomeLoanModel.CustomerGoal;
import com.ctm.model.homeloan.HomeLoanModel.CustomerSituation;
import com.ctm.model.homeloan.HomeLoanModel.RepaymentOptions;

public class HomeLoanService {

	public static HomeLoanModel mapParametersToModel(HttpServletRequest request) {

		HomeLoanModel model = new HomeLoanModel();

		/* TEST
		hlpsrModel.setCustomerSituation(CustomerSituation.FIRST_HOME_BUYER);
		hlpsrModel.setCustomerGoal(CustomerGoal.BUY_FIRST_HOME);
		hlpsrModel.setState("QLD");
		hlpsrModel.setPurchasePrice(500000);
		hlpsrModel.setLoanAmount(400000);
		hlpsrModel.setRepaymentOption(RepaymentOptions.PRINCIPAL_AND_INTEREST);
		hlpsrModel.setLoanTerm(30);
		hlpsrModel.setExistingPropertiesWorth(0);
		hlpsrModel.setAmountOwingOnLoan(0);

		//hlpsrModel.setRateVariable(true);
		//hlpsrModel.setRateFixed(true);
		//hlpsrModel.setLineOfCredit(true);
		//hlpsrModel.setIntroRate(true);
		//hlpsrModel.setRepaymentsWeekly(true);
		*/

		String value;

		value = request.getParameter("transactionId");
		if (value != null && value.length() > 0) {
			model.setTransactionId(Long.parseLong(value));
		}

		//
		// Map mandatory request parameters to model
		//
		value = request.getParameter("homeloan_results_pageNumber");
		if (value != null && value.length() > 0) {
			model.setPageNumber(Integer.parseInt(value));
		}

		value = request.getParameter("homeloan_results_loanTerm");
		if (value != null && value.length() > 0) {
			model.setLoanTerm(Integer.parseInt(value));
		}

		value = request.getParameter("homeloan_details_situation");
		if (value != null && value.length() > 0) {
			model.setCustomerSituation(CustomerSituation.findByCode(value));
		}

		value = request.getParameter("homeloan_details_goal");
		if (value != null && value.length() > 0) {
			model.setCustomerGoal(CustomerGoal.findByCode(value));
		}

		value = request.getParameter("homeloan_details_state");
		if (value != null) {
			model.setState(value);
		}

		// Name can also be overwritten on the enquiry step - see below
		value = request.getParameter("homeloan_contact_firstName");
		if (value != null) {
			model.setContactFirstName(value);
		}
		value = request.getParameter("homeloan_contact_lastName");
		if (value != null) {
			model.setContactSurname(value);
		}

		value = request.getParameter("homeloan_loanDetails_purchasePrice");
		if (value != null && value.length() > 0) {
			model.setPurchasePrice(Math.abs(Integer.parseInt(value)));
		}

		value = request.getParameter("homeloan_loanDetails_loanAmount");
		if (value != null && value.length() > 0) {
			model.setLoanAmount(Math.abs(Integer.parseInt(value)));
		}

		value = request.getParameter("homeloan_loanDetails_interestRate");
		if (value != null && value.length() > 0) {
			model.setRepaymentOption(RepaymentOptions.findByCode(value));
		}

		//
		// Map optional request parameters to model
		//
		value = request.getParameter("homeloan_loanDetails_productVariable");
		if (value != null && value.equals("Y")) {
			model.setRateVariable(true);
		}

		value = request.getParameter("homeloan_loanDetails_productFixed");
		if (value != null && value.equals("Y")) {
			model.setRateFixed(true);
		}

		value = request.getParameter("homeloan_details_amountOwing");
		if (value != null && value.length() > 0) {
			model.setAmountOwingOnLoan(Math.abs(Integer.parseInt(value)));
		}

		value = request.getParameter("homeloan_details_assetAmount");
		if (value != null && value.length() > 0) {
			model.setExistingPropertiesWorth(Math.abs(Integer.parseInt(value)));
		}

		//
		// Filters
		//
		value = request.getParameter("homeloan_fees_noApplication");
		if (value != null && value.equals("Y")) {
			model.setNoApplicationFees(true);
		}

		value = request.getParameter("homeloan_fees_noOngoing");
		if (value != null && value.equals("Y")) {
			model.setNoOngoingFees(true);
		}

		value = request.getParameter("homeloan_features_redraw");
		if (value != null && value.equals("Y")) {
			model.setRedrawFacility(true);
		}

		value = request.getParameter("homeloan_features_offset");
		if (value != null && value.equals("Y")) {
			model.setMortgageOffset(true);
		}

		value = request.getParameter("homeloan_features_bpay");
		if (value != null && value.equals("Y")) {
			model.setBpayAccess(true);
		}

		value = request.getParameter("homeloan_features_onlineBanking");
		if (value != null && value.equals("Y")) {
			model.setInternetBanking(true);
		}

		value = request.getParameter("homeloan_features_extraRepayments");
		if (value != null && value.equals("Y")) {
			model.setExtraRepayments(true);
		}

		value = request.getParameter("homeloan_loanDetails_productLineOfCredit");
		if (value != null && value.equals("Y")) {
			model.setLineOfCredit(true);
		}

		value = request.getParameter("homeloan_loanDetails_productLowIntroductoryRate");
		if (value != null && value.equals("Y")) {
			model.setIntroRate(true);
		}

		value = request.getParameter("homeloan_results_frequency_monthly");
		if (value != null && value.equals("Y")) {
			model.setRepaymentsMonthly(true);
		}

		value = request.getParameter("homeloan_results_frequency_fortnightly");
		if (value != null && value.equals("Y")) {
			model.setRepaymentsFortnightly(true);
		}

		value = request.getParameter("homeloan_results_frequency_weekly");
		if (value != null && value.equals("Y")) {
			model.setRepaymentsWeekly(true);
		}

		// --------------------------------------------------
		// Step 1
		// --------------------------------------------------

		value = request.getParameter("homeloan_details_suburb");
		if (value != null) {
			model.setAddressCity(value);
		}

		value = request.getParameter("homeloan_details_postcode");
		if (value != null) {
			model.setAddressPostcode(value);
		}

		// --------------------------------------------------
		// Enquiry page
		// --------------------------------------------------

		value = request.getParameter("homeloan_product_id");
		if (value != null) {
			model.setProductId(value);
		}

		value = request.getParameter("homeloan_enquiry_newLoan_contribution");
		if (value != null && value.length() > 0) {
			model.setDepositAmount(Math.abs(Integer.parseInt(value)));
		}

		value = request.getParameter("homeloan_enquiry_contact_firstName");
		if (value != null && value.length() > 0) {
			model.setContactFirstName(value);
		}
		value = request.getParameter("homeloan_enquiry_contact_lastName");
		if (value != null && value.length() > 0) {
			model.setContactSurname(value);
		}

		value = request.getParameter("homeloan_enquiry_contact_email");
		if (value != null) {
			model.setEmailAddress(value);
		}

		value = request.getParameter("homeloan_enquiry_contact_contactNumber");
		if (value != null) {
			model.setContactPhoneNumber(value);
		}

		value = request.getParameter("homeloan_enquiry_contact_bestContact");
		if (value != null) {
			model.setContactBestContact(value);
		}

		value = request.getParameter("homeloan_enquiry_contact_bestTime");
		if (value != null) {
			model.setContactBestTime(value);
		}

		value = request.getParameter("homeloan_enquiry_newLoan_foundAProperty");
		if (value != null && value.equals("Y")) {
			model.setFoundAProperty(true);
		}

		value = request.getParameter("homeloan_enquiry_newLoan_offerTime");
		if (value != null) {
			model.setOfferTime(value);
		}

		value = request.getParameter("homeloan_enquiry_newLoan_propertyType");
		if (value != null) {
			model.setPropertyType(value);
		}

		value = request.getParameter("homeloan_enquiry_newLoan_employmentType");
		if (value != null) {
			model.setEmploymentStatus(value);
		}

		value = request.getParameter("homeloan_enquiry_newLoan_additionalInformation");
		if (value != null) {
			model.setAdditionalInformation(value);
		}



		return model;
	}

}
