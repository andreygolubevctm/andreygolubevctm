package com.ctm.services.leadfeed.car.AGIS;

import org.apache.log4j.Logger;

import com.ctm.model.leadfeed.AGISLeadFeedRequest;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.leadfeed.car.AGISCarLeadFeedRequest;
import com.ctm.model.leadfeed.car.AGISCarLeadFeedRequest.MessageData;
import com.ctm.model.leadfeed.car.AGISCarLeadFeedRequest.StyleCodeMapping;
import com.ctm.services.leadfeed.AGISLeadFeedService;

public class AGISCarLeadFeedService extends AGISLeadFeedService {

	public static enum LeadType{
		CALL_ME_BACK, BEST_PRICE
	}

	private static Logger logger = Logger.getLogger(AGISCarLeadFeedService.class.getName());

	public AGISCarLeadFeedService(){
		super();
	}

	public AGISLeadFeedRequest getModel(LeadType leadType, LeadFeedData leadData) {

		MessageData messageData = null;

		if(leadType == LeadType.CALL_ME_BACK){
			if(leadData.getBrandCode().equalsIgnoreCase(StyleCodeMapping.COMPARE_THE_MARKET.getCtmCode())){
				messageData = AGISCarLeadFeedRequest.MessageData.CTM_REQUEST_CALLBACK;
			}else if(leadData.getBrandCode().equalsIgnoreCase(StyleCodeMapping.CAPTAIN_COMPARE.getCtmCode())){
				messageData = AGISCarLeadFeedRequest.MessageData.CAPTAIN_COMPARE_REQUEST_CALLBACK;
			}else if(leadData.getBrandCode().equalsIgnoreCase(StyleCodeMapping.CHOOSI.getCtmCode())){
				messageData = AGISCarLeadFeedRequest.MessageData.CHOOSI_REQUEST_CALLBACK;
			}

		}else if(leadType == LeadType.BEST_PRICE){
			if(leadData.getBrandCode().equalsIgnoreCase(StyleCodeMapping.COMPARE_THE_MARKET.getCtmCode())){
				messageData = AGISCarLeadFeedRequest.MessageData.CTM_BEST_PRICE;
			}else if(leadData.getBrandCode().equalsIgnoreCase(StyleCodeMapping.CAPTAIN_COMPARE.getCtmCode())){
				messageData = AGISCarLeadFeedRequest.MessageData.CAPTAIN_COMPARE_BEST_PRICE;
			}else if(leadData.getBrandCode().equalsIgnoreCase(StyleCodeMapping.CHOOSI.getCtmCode())){
				messageData = AGISCarLeadFeedRequest.MessageData.CHOOSI_BEST_PRICE;
			}
		} else {
			logger.error("[Lead feed] Unable to find correct message Data");
		}

		AGISLeadFeedRequest model = new AGISCarLeadFeedRequest(messageData ,leadData);

		return model;
	}

}
