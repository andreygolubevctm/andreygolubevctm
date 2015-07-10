package com.ctm.services.leadfeed;

import com.ctm.dao.leadfeed.BestPriceLeadsDao;
import org.apache.log4j.Logger;

import com.ctm.services.AccessTouchService;
import com.ctm.services.ContentService;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.content.Content;
import com.ctm.model.leadfeed.LeadFeedData;

import java.util.ArrayList;
import java.util.Date;

public abstract class LeadFeedService {

	private static Logger logger = Logger.getLogger(LeadFeedService.class.getName());

	protected Content ignoreBecauseOfField = null;
	protected String ignorePhoneRule = null;

	public static enum LeadType{
		CALL_DIRECT("callDirectLeadFeedService"),
		CALL_ME_BACK("getACallLeadFeedService"),
		BEST_PRICE("bestPriceLeadFeedService"),
		NOSALE_CALL("noSaleCallLeadFeedService"),
		FOLLOWUP_CALL("followupLeadFeedService");

		private final String serviceUrlFlag;

		LeadType(String serviceUrlFlag) {
			this.serviceUrlFlag = serviceUrlFlag;
		}

		public String getServiceUrlFlag() {
			return serviceUrlFlag;
		}
	};

	public static enum LeadResponseStatus{
		SUCCESS,
		FAILURE,
		SKIPPED
	};

	public LeadResponseStatus callDirect(LeadFeedData leadData) throws LeadFeedException {
		return processGateway(LeadType.CALL_DIRECT, leadData, Touch.TouchType.CALL_DIRECT);
	}

	public LeadResponseStatus callMeBack(LeadFeedData leadData) throws LeadFeedException {
		return processGateway(LeadType.CALL_ME_BACK, leadData, Touch.TouchType.LEAD_CALL_ME_BACK);
	}

	public LeadResponseStatus noSaleCall(LeadFeedData leadData) throws LeadFeedException {

		Content content = null;
		try {
			ContentService contentService = new ContentService();
			content = contentService.getContent("noSaleLeadOn", 0, leadData.getVerticalId(), leadData.getEventDate(), false);
		} catch(Exception e) {
			logger.error("[Lead feed] Exception checking noSaleLead is turned on in content_control",e);
			return LeadResponseStatus.SKIPPED;
		}

		if(content != null && content.getContentValue() == null || content.getContentValue().equalsIgnoreCase("Y")) {
			return processGateway(LeadType.NOSALE_CALL, leadData, Touch.TouchType.NOSALE_CALL);
		} else {
			logger.info("[Lead feed] Skipped noSaleLead as feed not turned on in content_control");
			return LeadResponseStatus.SKIPPED;
		}
	}

	public LeadResponseStatus bestPrice(LeadFeedData leadData) throws LeadFeedException {
		return processGateway(LeadType.BEST_PRICE, leadData, Touch.TouchType.LEAD_BEST_PRICE);
	}

	/**
	 * processGateway() will filter out any invalid lead requests and skip sending the lead and just
	 * record the touch. This is to prevent leads being generated from preload or gomez testing etc
	 *
	 * @param leadType
	 * @param leadData
	 * @param touchType
	 * @return
	 * @throws LeadFeedException
	 */
	private LeadResponseStatus processGateway(LeadType leadType, LeadFeedData leadData, TouchType touchType) throws LeadFeedException {
		if(isTestOnlyLead(leadData)) {
			// Don't process or record touch for test data - simply return success
			return LeadResponseStatus.SUCCESS;
		} else {
			return process(leadType, leadData, touchType);
		}
	}

	abstract protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType);

	public String processBestPriceLeads (int brandCodeId, String verticalCode, int frequency, Date serverDate){

		BestPriceLeadsDao bestPriceDao = new BestPriceLeadsDao();
		Integer successCount = 0;
		Integer failureCount = 0;
		try {
			ArrayList<LeadFeedData> leads = bestPriceDao.getLeads(brandCodeId, verticalCode, frequency, serverDate);
			if(!leads.isEmpty()) {
				for (LeadFeedData lead : leads) {
					try {
						LeadResponseStatus response = bestPrice(lead);
						if(response == LeadResponseStatus.SUCCESS) {
							successCount++;
						} else {
							failureCount++;
						}
					} catch(LeadFeedException e) {
						failureCount++;
						logger.error(e.getMessage());
					}
				}
			}
		} catch(DaoException e) {
			logger.error("[Lead feed] Exception processing lead feed message",e);
		}

		return "{\"styleCode\":" + brandCodeId + ",\"success\":" + successCount + ",\"failure\":" + failureCount + "}";
	}

	protected Boolean recordTouch(String touchType, LeadFeedData leadData) {
		AccessTouchService touchService = new AccessTouchService();

		if(!leadData.getProductId().isEmpty())
			return touchService.recordTouchWithProductCode(leadData.getTransactionId(), touchType, Touch.ONLINE_USER, leadData.getProductId());
		else
			return touchService.recordTouch(leadData.getTransactionId(), touchType, Touch.ONLINE_USER);
	}

	/**
	 * isTestOnlyLead() will check whether the email or phone number in the lead data has been
	 * flagged as test data.
	 *
	 * @param leadData
	 * @return
	 * @throws LeadFeedException
	 */
	protected Boolean isTestOnlyLead(LeadFeedData leadData) throws LeadFeedException {
		try {
			if(ignoreBecauseOfField instanceof Content == false) {
				ContentService contentService = new ContentService();
				ignoreBecauseOfField = contentService.getContent("ignoreMatchingFormField", leadData.getBrandId(), leadData.getVerticalId(), leadData.getEventDate(), true);
				ignorePhoneRule = ignoreBecauseOfField.getSupplementaryValueByKey("phone");
			}
			if(ignorePhoneRule != null && !ignorePhoneRule.isEmpty() && ignorePhoneRule.contains(leadData.getPhoneNumber())) {
				logger.debug("[Lead feed] Lead identified as test-only because of phone number: "+leadData.getPhoneNumber()+"; Transaction ID: "+leadData.getTransactionId());
				return true;
			} else {
				return false;
			}
		} catch(DaoException e) {
			throw new LeadFeedException(e.getMessage(), e);
		}
	}
}
