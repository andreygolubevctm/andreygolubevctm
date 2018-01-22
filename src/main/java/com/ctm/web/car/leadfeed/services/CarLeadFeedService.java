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
import com.ctm.web.core.leadfeed.model.CTMCarLeadFeedRequestMetadata;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.ServiceConfigurationService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class CarLeadFeedService extends LeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CarLeadFeedService.class);
	public static final String COMPREHENSIVE = "COMPREHENSIVE";

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
	 * Creates and returns an instance of {@linkplain IProviderLeadFeedService} based on following conditions:
	 * <p>
	 * Send the lead to ctm call center (ctm_leads)
	 * - if given car lead is for BUDD
	 * - lead type is BEST_PRICE,
	 * - and has `comprehensive` car cover,
	 * - and `ctm_leads` config is enabled.
	 * <p>
	 * Don't send the lead to CTM or A&G call center
	 * - if given car lead is for BUDD
	 * - lead type is BEST_PRICE,
	 * - and has `NON comprehensive` car cover,
	 * - and `ctm_leads` config is enabled.
	 * <p>
	 * Send the lead to auto and general call center (A&G)
	 * - all other non BEST_PRICE types of car leads.
	 *
	 * @param leadType lead type.
	 * @param leadData lead data.
	 * @return {@linkplain IProviderLeadFeedService} instance or null.
	 */
	private IProviderLeadFeedService getProviderLeadFeedServiceForBudd(final LeadType leadType, final LeadFeedData leadData) throws LeadFeedException {
		ServiceConfiguration serviceConfig = getServiceConfiguration();

		final Boolean carCtmLeadsEnabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", leadData.getBrandId(), 0, ServiceConfigurationProperty.Scope.SERVICE));
		final String ctmLeadsUrl = serviceConfig.getPropertyValueByKey("url", leadData.getBrandId(), 0, ServiceConfigurationProperty.Scope.SERVICE);

		if (carCtmLeadsEnabled && leadType == LeadType.BEST_PRICE && isCarComprehensiveCover(leadData)) {
			return new CTMCarLeadFeedService(ctmLeadsUrl, new RestTemplate(clientHttpRequestFactory()));
		}

		if (carCtmLeadsEnabled && leadType == LeadType.BEST_PRICE && !isCarComprehensiveCover(leadData)) {
			//Don't send leads to ctm or A&G call center.
			LOGGER.info("[Lead feed] BUDD BEST_PRICE non-comprehensive car lead feed fond. Not sending to any call centers {}, {}", kv("leadType", leadType), kv("leadData", leadData));
			return null;
		}

		return new AGISCarLeadFeedService();
	}

	private boolean isCarComprehensiveCover(final LeadFeedData leadData) {
		if(leadData == null) return false;

		if(leadData.getMetadata() instanceof CTMCarLeadFeedRequestMetadata){
			final CTMCarLeadFeedRequestMetadata metadata = (CTMCarLeadFeedRequestMetadata) leadData.getMetadata();
			return StringUtils.equalsIgnoreCase(metadata.getCoverType(), COMPREHENSIVE);
		}

		return false;
	}

	private static ServiceConfiguration getServiceConfiguration() throws LeadFeedException {
		ServiceConfiguration serviceConfig = null;
		try {
			serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", CTMCarLeadFeedService.CAR_VERTICAL_ID);
		} catch (DaoException e) {
			throw new LeadFeedException(e.getMessage(), e);
		} catch (ServiceConfigurationException e) {
			throw new LeadFeedException(e.getMessage(), e);
		}

		if (serviceConfig == null) {
			throw new LeadFeedException("[lead feed] ServiceConfiguration is null");
		}

		return serviceConfig;
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
