package com.ctm.services.homeloan;

import com.ctm.dao.transaction.TransactionDetailsDao;
import com.ctm.dao.homeloan.HomeloanUnconfirmedLeadsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Touch;
import com.ctm.model.TransactionDetail;
import com.ctm.model.homeloan.HomeLoanModel;
import com.ctm.model.homeloan.HomeLoanModel.CustomerGoal;
import com.ctm.model.homeloan.HomeLoanModel.CustomerSituation;
import com.ctm.model.homeloan.HomeLoanModel.RepaymentOptions;
import com.ctm.router.homeloan.HomeLoanRouter;
import com.ctm.security.StringEncryption;
import com.ctm.services.AccessTouchService;
import com.ctm.services.FatalErrorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;

public class HomeLoanService {

	private TransactionDetailsDao transactionDetailsDao;
	private HomeloanUnconfirmedLeadsDao homeloanLeadsDao;
	private HomeLoanOpportunityService opportunityService;

	public HomeLoanService(TransactionDetailsDao transactionDetailsDao , HomeloanUnconfirmedLeadsDao homeloanLeadsDao , HomeLoanOpportunityService opportunityService){
		this.transactionDetailsDao = transactionDetailsDao;
		this.homeloanLeadsDao = homeloanLeadsDao;
		this.opportunityService = opportunityService;

	}

	/** TODO: used by homeloan_submit.jsp refactor homeloan_submit.jsp to java and remove this constructor
	 *
	 */
	public HomeLoanService(){
		this.transactionDetailsDao = new TransactionDetailsDao();
		this.homeloanLeadsDao = new HomeloanUnconfirmedLeadsDao();
		this.opportunityService = new HomeLoanOpportunityService();

	}

	public static HomeLoanModel mapParametersToModel(HttpServletRequest request) {

		HomeLoanModel model = new HomeLoanModel();

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
		model.contact = HomeLoanFormParser.parseNames(request);

		value = request.getParameter("homeloan_loanDetails_purchasePrice");
		if (value != null && value.length() > 0) {
			model.setPurchasePrice((int)Double.parseDouble(value));
		}

		value = request.getParameter("homeloan_loanDetails_loanAmount");
		if (value != null && value.length() > 0) {
			model.setLoanAmount((int)Double.parseDouble(value));
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

	public synchronized void scheduledLeadGenerator(HttpServletRequest request) {

		JSONObject json = null;
		Logger LOGGER = LoggerFactory.getLogger(HomeLoanRouter.class);
		AccessTouchService touch = new AccessTouchService();

		try {
			List<HomeLoanModel> leads = homeloanLeadsDao.getUnconfirmedTransactionIds();

			for(HomeLoanModel lead : leads) {

				/**
				 * Ignore leads with names like these.
				 */
				if(lead.getContactFirstName() == null || lead.getContactFirstName().isEmpty()
						|| lead.getContactSurname() == null || lead.getContactSurname().isEmpty()
						|| lead.getContactPhoneNumber() == null || lead.getContactPhoneNumber().isEmpty()
						|| lead.getContactFirstName() ==  "UnknownFirstName " || lead.getContactSurname() == "UnknownLastName") {
					continue;
				}

				json = opportunityService.submitOpportunity(request, lead);

				if(json != null && json.has("responseData")) {
					try {
						String out = StringEncryption.decrypt(HomeLoanOpportunityService.SECRET_KEY, json.getString("responseData"));
						JSONObject responseJson = new JSONObject(out);
						if(responseJson.has("flexOpportunityId")) {
							touch.recordTouch(lead.getTransactionId(), Touch.TouchType.CALL_FEED.getCode());
							// Add a new tran detail
							TransactionDetail transactionDetailNew = new TransactionDetail();
							transactionDetailNew.setXPath("homeloan/flexOpportunityId");
							transactionDetailNew.setTextValue(responseJson.getString("flexOpportunityId"));
							transactionDetailsDao.addTransactionDetails(lead.getTransactionId(), transactionDetailNew);
						}
					} catch (JSONException | GeneralSecurityException e) {
						LOGGER.error("Failed to decrypt opportunity id {}, {}", kv("transactionId", lead.getTransactionId()), e);
						FatalErrorService.logFatalError(e, 0, "/cron/hourly/homeloan/flexOutboundLead.json", "ctm", true, lead.getTransactionId());
					}
				}
			}

		} catch(DaoException e) {
			LOGGER.error("HomeLoan opportunity cron failed", e);
			FatalErrorService.logFatalError(e, 0, "/cron/hourly/homeloan/flexOutboundLead.json" , "ctm", true);
		}


	}

}
