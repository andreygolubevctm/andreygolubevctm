package com.ctm.web.core.leadfeed.services;

import com.ctm.ailead.ws.*;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.EnvironmentException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadType;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ProviderService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.webservice.WebServiceUtils;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.message.Message;
import org.joda.time.LocalDate;
import org.joda.time.LocalTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.FAILURE;
import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.SUCCESS;

public abstract class AILeadFeedService implements IProviderLeadFeedService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AILeadFeedService.class);

	private static final ObjectFactory OBJECT_FACTORY = new ObjectFactory();

	private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormat.forPattern("HH:mm");

	/**
	 * isQualifiedLead() tests valid lead data exists according to the lead type
	 *
	 */
	public LeadResponseStatus process(LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		LeadResponseStatus feedResponse = FAILURE;
		try {

			final Provider provider = ProviderService.getProvider(leadData.getPartnerBrand(), ApplicationService.getServerDate());
			final ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration(leadType.getServiceUrlFlag(), leadData.getVerticalId());


			// Generate the lead feed model
			UploadQuickLead leadModel = buildRequest(provider, serviceConfig, leadType, leadData);
			// Get the relevant brand+vertical settings
			PageSettings pageSettings = SettingsService.getPageSettings(leadData.getBrandId(), leadData.getVerticalCode());
			final String serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", leadData.getBrandId(), provider.getId(), ServiceConfigurationProperty.Scope.SERVICE);
			UploadQuickLeadResponse response = sendRequest(pageSettings, leadModel, serviceUrl, leadData.getTransactionId());

			final Optional<SSStatus> status = Optional.ofNullable(response)
					.map(UploadQuickLeadResponse::getUploadQuickLeadResult)
					.map(SSResults::getStatusCode);


			if(status.filter(code -> code == SSStatus.STATUS_SUCCESS)
					.isPresent()){
				feedResponse = SUCCESS;
			}

			LOGGER.debug("[Lead feed] Response Status from AI {}", kv("status", status.orElse(null)));

		} catch (EnvironmentException | VerticalException | IOException | DaoException | ServiceConfigurationException e) {
			LOGGER.error("[Lead feed] Failed adding lead feed message {}", kv("leadData", leadData), e);
			throw new LeadFeedException(e.getMessage(), e);
		}

		return feedResponse;

	}

	private UploadQuickLeadResponse sendRequest(PageSettings settings, UploadQuickLead request, String serviceUrl, Long transactionId) throws IOException {
		try {

			final SSGateway ssGateway = new SSGateway();
			final SSGatewaySoap ssGatewaySoap = ssGateway.getSSGatewaySoap();

			Client client = (Client)ssGatewaySoap;
			client.getRequestContext().put(Message.ENDPOINT_ADDRESS, serviceUrl);

			WebServiceUtils.initProxy(client);
			WebServiceUtils.setLogging(client, settings, transactionId, "AI_LEEDFEED");
			LOGGER.debug("[Lead feed] Sending message to AI");

			return ssGatewaySoap.uploadQuickLead(request);
		} catch (Exception e) {
			LOGGER.error("[Lead feed] Failed sending lead feed message to AGIS {}, {}, {}", kv("settings", settings),
					kv("serviceUrl", serviceUrl), kv("transactionId", transactionId), e);
			throw new IOException(e);
		}
	}

	protected UploadQuickLead buildRequest(Provider provider, ServiceConfiguration serviceConfig, LeadType leadType, LeadFeedData leadData) throws LeadFeedException {

		final UploadQuickLead request = OBJECT_FACTORY.createUploadQuickLead();
		final SSQuickLead quickLead = OBJECT_FACTORY.createSSQuickLead();
		request.setLeadDetails(quickLead);
		request.setUsername(serviceConfig.getPropertyValueByKey("username", leadData.getBrandId(), provider.getId(), ServiceConfigurationProperty.Scope.SERVICE));
		request.setPassword(serviceConfig.getPropertyValueByKey("password", leadData.getBrandId(), provider.getId(), ServiceConfigurationProperty.Scope.SERVICE));

		quickLead.setPartnerCode(serviceConfig.getPropertyValueByKey("partnerCode", leadData.getBrandId(), provider.getId(), ServiceConfigurationProperty.Scope.SERVICE));
		quickLead.setAgentCode(serviceConfig.getPropertyValueByKey("agentCode", leadData.getBrandId(), provider.getId(), ServiceConfigurationProperty.Scope.SERVICE));
		quickLead.setSubPartnerCode(serviceConfig.getPropertyValueByKey("subPartnerCode", leadData.getBrandId(), provider.getId(), ServiceConfigurationProperty.Scope.SERVICE));
		quickLead.setTransactionID(leadData.getTransactionId());
		quickLead.setLeadType(getLeadType(leadType));
		quickLead.setQuoteNumber(Long.parseLong(leadData.getPartnerReference()));
		quickLead.setFirstName(leadData.getClientName());
		quickLead.setPhoneNumber(leadData.getPhoneNumber());
		quickLead.setCallBackDate(LocalDate.now().toLocalDateTime(LocalTime.fromMillisOfDay(0)));
		quickLead.setCallBackTime(TIME_FORMATTER.print(LocalTime.now()));
		quickLead.setComments("No Comment");

		return request;
	}

	protected String getLeadType(LeadType leadType) throws LeadFeedException{
		switch (leadType) {
			case CALL_DIRECT: return "CD";
			case CALL_ME_BACK: return "CB";
			case NOSALE_CALL: return "NPO";
			case BEST_PRICE: return "BP";
			default:
				throw new LeadFeedException("[Lead feed] Not supported leadType " + leadType);
		}
	}

}
