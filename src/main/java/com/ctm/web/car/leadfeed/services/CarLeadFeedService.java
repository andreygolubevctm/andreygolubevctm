package com.ctm.web.car.leadfeed.services;

import com.ctm.web.car.leadfeed.services.AGIS.AGISCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.AI.AICarLeadFeedService;
import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.REIN.REINCarLeadFeedService;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.ServiceConfigurationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class CarLeadFeedService extends LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarLeadFeedService.class);

	public CarLeadFeedService(BestPriceLeadsDao bestPriceDao) {
		super(bestPriceDao, new ContentService(),
				new LeadFeedTouchService(new AccessTouchService())
		);
	}

	protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) throws LeadFeedException {

		LeadResponseStatus responseStatus;

 		IProviderLeadFeedService providerLeadFeedService = null;

		try {
			LOGGER.debug("[Lead feed] Prepare to send lead {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));

			switch(leadData.getPartnerBrand()) {

				case "BUDD":
					providerLeadFeedService = getProviderLeadFeedServiceForBudd(leadType, leadData);
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
	private IProviderLeadFeedService getProviderLeadFeedServiceForBudd(final LeadType leadType, final LeadFeedData leadData) throws LeadFeedException {
		ServiceConfiguration serviceConfig = null;
		try {
			serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", CTMCarLeadFeedService.CAR_VERTICAL_ID);
		} catch (DaoException e) {
			throw new LeadFeedException(e.getMessage(), e);
		} catch (ServiceConfigurationException e) {
			throw new LeadFeedException(e.getMessage(), e);
		}

		LOGGER.info("BANANA: " + leadData.getBrandId());

		final Boolean carCtmLeadsEnabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", leadData.getBrandId(), 0, ServiceConfigurationProperty.Scope.SERVICE));
		final String ctmLeadsUrl = serviceConfig.getPropertyValueByKey("url", leadData.getBrandId(), 0, ServiceConfigurationProperty.Scope.SERVICE);

		if(carCtmLeadsEnabled && leadType == LeadType.BEST_PRICE) {
			return new CTMCarLeadFeedService(ctmLeadsUrl, new RestTemplate(clientHttpRequestFactory()));
		} else {
			return new AGISCarLeadFeedService();
		}
	}

	/**
	 * set timeout for the rest template as default is infinite which will block the thread.
	 * @return
	 */
	private ClientHttpRequestFactory clientHttpRequestFactory() {
		HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
		factory.setReadTimeout(5000);
		factory.setConnectTimeout(5000);
		return factory;
	}

}
