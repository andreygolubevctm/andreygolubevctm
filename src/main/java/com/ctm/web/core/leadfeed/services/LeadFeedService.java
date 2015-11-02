package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.services.AccessTouchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.Date;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public abstract class LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(LeadFeedService.class);
	private final BestPriceLeadsDao bestPriceDao;
	private final ContentService contentService;

	protected Content ignoreBecauseOfField = null;
	protected String ignorePhoneRule = null;

	public LeadFeedService(BestPriceLeadsDao bestPriceDao, ContentService contentService) {
		this.bestPriceDao = bestPriceDao;
		this.contentService = contentService;
	}

	public static enum LeadType{
		CALL_DIRECT("callDirectLeadFeedService"),
		CALL_ME_BACK("getACallLeadFeedService"),
		BEST_PRICE("bestPriceLeadFeedService"),
		NOSALE_CALL("noSaleCallLeadFeedService");

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
		recordTouch(Touch.TouchType.CALL_DIRECT.getCode(), leadData);
		return LeadResponseStatus.SUCCESS;
	}

	public LeadResponseStatus callMeBack(LeadFeedData leadData) throws LeadFeedException {
		return processGateway(LeadType.CALL_ME_BACK, leadData, Touch.TouchType.LEAD_CALL_ME_BACK);
	}

	public LeadResponseStatus noSaleCall(LeadFeedData leadData) throws LeadFeedException {

		Content content = null;
		try {
			content = contentService.getContent("noSaleLeadOn", 0, leadData.getVerticalId(), leadData.getEventDate(), false);
		} catch(Exception e) {
			LOGGER.error("[Lead feed] Exception checking noSaleLead is turned on in content_control {}", kv("leadData", leadData), e);
			return LeadResponseStatus.SKIPPED;
		}

		if(content != null && content.getContentValue() == null || content.getContentValue().equalsIgnoreCase("Y")) {
			return processGateway(LeadType.NOSALE_CALL, leadData, Touch.TouchType.NOSALE_CALL);
		} else {
			LOGGER.info("[Lead feed] Skipped noSaleLead as feed not turned on in content_control {}", kv("content", content));
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
	protected LeadResponseStatus processGateway(LeadType leadType, LeadFeedData leadData, TouchType touchType) throws LeadFeedException {
		if(isTestOnlyLead(leadData)) {
			// Don't process or record touch for test data - simply return success
			return LeadResponseStatus.SUCCESS;
		} else {
			return process(leadType, leadData, touchType);
		}
	}

	abstract protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType);

	public String processBestPriceLeads (int brandCodeId, String verticalCode, int frequency, Date serverDate){
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
						LOGGER.error("Failed processing best price leads {},{},{},{}", kv("brandCodeId", brandCodeId),
								kv("verticalCode", verticalCode), kv("frequency", frequency), kv("serverDate", serverDate));
					}
				}
			}
		} catch(DaoException e) {
			LOGGER.error("[Lead feed] Exception processing lead feed message {},{},{},{}", kv("brandCodeId", brandCodeId),
				kv("verticalCode", verticalCode), kv("frequency", frequency), kv("serverDate", serverDate), e);
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
				ignoreBecauseOfField = contentService.getContent("ignoreMatchingFormField", leadData.getBrandId(), leadData.getVerticalId(), leadData.getEventDate(), true);
				ignorePhoneRule = ignoreBecauseOfField.getSupplementaryValueByKey("phone");
			}
			if(ignorePhoneRule != null && !ignorePhoneRule.isEmpty() && ignorePhoneRule.contains(leadData.getPhoneNumber())) {
				LOGGER.debug("[Lead feed] Lead identified as test-only because of phone number {},{}", kv("phoneNumber", leadData.getPhoneNumber()),
					kv("transactionId", leadData.getTransactionId()));
				return true;
			} else {
				return false;
			}
		} catch(DaoException e) {
			throw new LeadFeedException(e.getMessage(), e);
		}
	}
}
