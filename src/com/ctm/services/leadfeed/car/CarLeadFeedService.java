package com.ctm.services.leadfeed.car;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import com.ctm.dao.leadfeed.BestPriceLeadsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.LeadFeedException;
import com.ctm.model.Touch.TouchType;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.services.leadfeed.LeadFeedService;
import com.ctm.services.leadfeed.car.AGIS.AGISCarLeadFeedService;

import java.util.Date;


public class CarLeadFeedService extends LeadFeedService {

	private static Logger logger = Logger.getLogger(CarLeadFeedService.class.getName());

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus = LeadResponseStatus.SUCCESS;

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

					AGISCarLeadFeedService leadFeedService = new AGISCarLeadFeedService();
					String response = leadFeedService.sendLeadFeedRequest(leadType, leadData);
					if(response.equalsIgnoreCase("ok")) {
						recordTouch(touchType.getCode(), leadData);
					} else {
						responseStatus = LeadResponseStatus.FAILURE;
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
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}



}
