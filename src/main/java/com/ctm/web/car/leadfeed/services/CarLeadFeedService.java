package com.ctm.web.car.leadfeed.services;

import com.ctm.web.car.leadfeed.services.AGIS.AGISCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.AI.AICarLeadFeedService;
import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.REIN.REINCarLeadFeedService;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.services.AccessTouchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class CarLeadFeedService extends LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarLeadFeedService.class);

	@Value("${ctm.car.lead.feed.service.enabled}")
	private Boolean ctmCarLeadFeedServiceEnabled;

	public CarLeadFeedService(BestPriceLeadsDao bestPriceDao) {
		super(bestPriceDao, new ContentService(),
				new LeadFeedTouchService(new AccessTouchService())
		);
	}

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) {

		LeadResponseStatus responseStatus;

 		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			LOGGER.debug("[Lead feed] Prepare to send lead {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));

			switch(leadData.getPartnerBrand()) {

				case "BUDD":
					providerLeadFeedService = getProviderLeadFeedServiceForBudd(leadType);
					break;
				case "EXPO":
				case "VIRG":
				case "EXDD":
				case "1FOW":
				case "RETI":
				case "OZIC":
				case "IECO":
				case "CBCK":
					providerLeadFeedService = new AGISCarLeadFeedService();
					break;
				case "WOOL":
					break;
				case "REIN":
					providerLeadFeedService = new REINCarLeadFeedService();
					break;
				case "AI":
					providerLeadFeedService = new AICarLeadFeedService();
					break;
			}

			responseStatus = getLeadResponseStatus(leadType, leadData, touchType, providerLeadFeedService);

		} catch(LeadFeedException e) {
			LOGGER.error("[Lead feed] Error adding lead feed message {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData),
				kv("touchType", touchType), e);
			responseStatus = LeadResponseStatus.FAILURE;
		}

		return responseStatus;
	}

	/**
	 * Car best price lead for BUDD should be send to ctm-leads. Rest of the leads to AGIS
	 *
	 * @param leadType
	 * @return
	 */
	private IProviderLeadFeedService getProviderLeadFeedServiceForBudd(final LeadType leadType) {
		//TODO use config ctmCarLeadFeedServiceEnabled
		if(leadType == LeadType.BEST_PRICE) {
			return new CTMCarLeadFeedService();
		} else {
			return new AGISCarLeadFeedService();
		}
	}

}
