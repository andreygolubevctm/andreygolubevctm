package com.ctm.services.leadfeed.car;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.ctm.dao.leadfeed.BestPriceLeadsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.car.AGIS.AGISCarLeadFeedService;
import com.ctm.services.leadfeed.car.AGIS.AGISCarLeadFeedService.LeadType;

import java.util.Date;


public class CarLeadFeedService extends LeadFeedService {

	private static Logger logger = Logger.getLogger(CarLeadFeedService.class.getName());

	public String callMeBack(LeadFeedData leadData){
		return process(LeadType.CALL_ME_BACK, leadData, Touch.TouchType.LEAD_CALL_ME_BACK);
	}

	public String bestPrice(LeadFeedData leadData){
		return process(LeadType.BEST_PRICE, leadData, Touch.TouchType.LEAD_BEST_PRICE);
	}


	private String process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		String response = null;

		try {

			switch(leadData.getPartnerBrand()) {

				case "BUDD":
				case "EXPO":
				case "VIRG":
				case "EXDD":
				case "1FOW":
				case "RETI":
				case "OZIC":
				case "IECO":
				case "CBCK":

					logger.info("[Lead feed] Prepare to send lead to AGIS brand "+leadType+"; Transaction ID: "+leadData.getTransactionId());

					String phoneTest = "0411111111,0755254545,0712345678";
					if(phoneTest.contains(leadData.getPhoneNumber())) {
						recordTouch(leadData.getTransactionId(), touchType.getCode());
						response = "ok";
					} else {
						AGISCarLeadFeedService leadFeedService = new AGISCarLeadFeedService();
						response = leadFeedService.sendLeadFeedRequest(leadType, leadData);
						if(response.equalsIgnoreCase("ok")) {
							recordTouch(leadData.getTransactionId(), touchType.getCode());
						}
					}

					break;

				case "WOOL":
					logger.debug("[Lead feed] No lead feed set up for WOOL "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					break;
				case "REIN":
					logger.debug("[Lead feed] No lead feed set up for REIN "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					break;
				case "AI":
					logger.debug("[Lead feed] No lead feed set up for AI "+leadType+"; Transaction ID: "+leadData.getTransactionId());
					break;
			}
		} catch(LeadFeedException e) {
			logger.error("[Lead feed] Exception adding lead feed message",e);
			response = e.getMessage();
		}

		return response;
	}

	public String processBestPriceLeads (int brandCodeId, String verticalCode, int frequency, Date serverDate){

		BestPriceLeadsDao bestPriceDao = new BestPriceLeadsDao();
		Integer successCount = 0;
		Integer failureCount = 0;
		try {
			ArrayList<LeadFeedData> leads = bestPriceDao.getLeads(brandCodeId, verticalCode, frequency, serverDate);
			if(!leads.isEmpty()) {
				for (LeadFeedData lead : leads) {

					String response = bestPrice(lead);

					if(response.equalsIgnoreCase("ok")) {
						successCount++;
					} else {
						failureCount++;
						logger.error(response);
					}

				}
			}
		} catch(DaoException e) {
			logger.error("[Lead feed] Exception processing lead feed message",e);
		}

		return "{\"styleCode\":" + brandCodeId + ",\"success\":" + successCount + ",\"failure\":" + failureCount + "}";
	}



}
