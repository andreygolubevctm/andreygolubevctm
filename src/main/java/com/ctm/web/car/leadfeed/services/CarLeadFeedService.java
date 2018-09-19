package com.ctm.web.car.leadfeed.services;

import com.ctm.web.car.leadfeed.services.AGIS.AGISCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.AI.AICarLeadFeedService;
import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.car.leadfeed.services.REIN.REINCarLeadFeedService;
import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.CTMCarLeadFeedRequestMetadata;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.model.Person;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch.TouchType;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import javax.naming.NamingException;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Process lead feed implementations specific to CAR
 */
public class CarLeadFeedService extends LeadFeedService {

    public static final String COMPREHENSIVE = "COMPREHENSIVE";
    private static final Logger LOGGER = LoggerFactory.getLogger(CarLeadFeedService.class);

    public CarLeadFeedService(BestPriceLeadsDao bestPriceDao) {
        super(bestPriceDao, new ContentService(),
                new LeadFeedTouchService(new AccessTouchService())
        );
    }

    /**
     * Check service_master and service_properties to see which providers are able to receive leads.
     * @return
     * @throws LeadFeedException
     */
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
     * Based on the partner brand code, choose a leadfeedservice and run the lead process.
     *
     * {@linkplain AGISCarLeadFeedService}
     * {@linkplain REINCarLeadFeedService}
     * {@linkplain AICarLeadFeedService}
     *
     * @see super.processGateway
     * @see this.getProviderLeadFeedServiceForBudd
     *
     * @param leadType
     * @param leadData
     * @param touchType
     * @return
     * @throws LeadFeedException
     */
    protected LeadResponseStatus process(LeadType leadType, LeadFeedData leadData, TouchType touchType) throws LeadFeedException {

        LeadResponseStatus responseStatus;

        IProviderLeadFeedService providerLeadFeedService = null;

        try {
            LOGGER.debug("[Lead feed] Prepare to send lead {}, {}, {}", kv("leadType", leadType), kv("leadData", leadData), kv("touchType", touchType));

            switch (leadData.getPartnerBrand()) {

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

        } catch (LeadFeedException e) {
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
     * - and has `comprehensive` car cover,
     * - and `ctm_leads` config is enabled.
     * <p>
     * Don't send the lead to CTM or A&G call center
     * - if given car lead is for BUDD
     * - and has `NON comprehensive` car cover,
     * - and `ctm_leads` config is enabled.

     *
     * @param leadType lead type.
     * @param leadData lead data.
     * @return {@linkplain IProviderLeadFeedService} instance or null.
     */
    private IProviderLeadFeedService getProviderLeadFeedServiceForBudd(final LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
        ServiceConfiguration serviceConfig = getServiceConfiguration();
        final Boolean carCtmLeadsEnabled = Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", leadData.getBrandId(), 0, ServiceConfigurationProperty.Scope.SERVICE));
        final String ctmLeadsUrl = serviceConfig.getPropertyValueByKey("url", leadData.getBrandId(), 0, ServiceConfigurationProperty.Scope.SERVICE);

        if (carCtmLeadsEnabled) {
            leadData = appendLeadConcat(leadData);
        }

        if (carCtmLeadsEnabled && isCarComprehensiveCover(leadData)) {
            return new CTMCarLeadFeedService(ctmLeadsUrl, new RestTemplate(clientHttpRequestFactory()));
        }

        if (carCtmLeadsEnabled && !isCarComprehensiveCover(leadData)) {
            //Don't send leads to ctm or A&G call center.
            LOGGER.info("[Lead feed] BUDD BEST_PRICE non-comprehensive car lead feed fond. Not sending to any call centers {}, {}", kv("leadType", leadType), kv("leadData", leadData));
            return null;
        }

        return new AGISCarLeadFeedService();
    }

    private boolean isCarComprehensiveCover(final LeadFeedData leadData) {
        if (leadData == null) return false;

        if (leadData.getMetadata() instanceof CTMCarLeadFeedRequestMetadata) {
            final CTMCarLeadFeedRequestMetadata metadata = (CTMCarLeadFeedRequestMetadata) leadData.getMetadata();
            return StringUtils.equalsIgnoreCase(metadata.getCoverType(), COMPREHENSIVE);
        }

        return false;
    }

    /**
     * set timeout for the rest template as default is infinite which will block the thread.
     *
     * @return
     */
    private ClientHttpRequestFactory clientHttpRequestFactory() {
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setReadTimeout(5000);
        factory.setConnectTimeout(5000);
        return factory;
    }

    /**
     * Det additional data for person and metadata details.
     * @param leadData
     * @return
     */
    private LeadFeedData appendLeadConcat(LeadFeedData leadData) {
        LeadFeedData leadDataWithMeta = leadData;
        try {
            SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
            String sql = "SELECT feedinfo.transactionId, leadInfo,propensityScore ,leadNo, provider FROM" +
                    "(SELECT productId, transactionId, `value` as leadInfo FROM aggregator.results_properties WHERE transactionId = " + leadData.getTransactionId() + " AND property = 'leadfeedinfo' ) feedinfo" +
                    " JOIN" +
                    "    (SELECT productId, transactionId, `value` as provider FROM aggregator.results_properties WHERE transactionId = " + leadData.getTransactionId() + " AND property = 'brandCode') provider" +
                    " ON provider.transactionId = feedinfo.transactionId" +
                    "  LEFT JOIN" +
                    " (SELECT productId, transactionId, `value` as propensityScore FROM aggregator.results_properties WHERE transactionId = " + leadData.getTransactionId() + " AND property = 'PropensityScore') prop" +
                    " ON feedinfo.transactionId = prop.transactionId" +
                    "     and provider.productId = prop.productId" +
                    " LEFT JOIN" +
                    " (SELECT productId, transactionId, `value` as leadNo FROM aggregator.results_properties WHERE transactionId = " + leadData.getTransactionId() + " AND property = 'leadNo') leadno" +
                    " ON feedinfo.transactionId = leadno.transactionId" +
                    "     and provider.productId = leadno.productId" +
                    " WHERE provider = 'BUDD'" +
                    " AND propensityScore is not null" +
                    "    LIMIT 1;";
            PreparedStatement stmt;

            /* Source transactions that have progressed through to results page in the last x minutes
             * and/or those with existing leads triggered (which imply results have been seen) */
            stmt = dbSource.getConnection().prepareStatement(sql);
            ResultSet resultSet = stmt.executeQuery();
            while (resultSet.next()) {
                String[] leadConcat = resultSet.getString("leadInfo").split("\\|\\|", -1);
                if (leadConcat.length >= CarQuote.LEAD_FEED_INFO_SIZE_V1) {
                    String curLeadNumber = resultSet.getString("leadNo");
                    String propensityScore = resultSet.getString("propensityScore");
                    String curIdentifier = leadConcat[2];
                    String phoneNumber = leadConcat[1];

                    String fullName = leadConcat[0];
                    String state = leadConcat[3];
                    leadData.setPhoneNumber(phoneNumber);
                    leadData.setClientName(fullName);
                    leadData.setState(state);
                    if (leadConcat.length >= CarQuote.LEAD_FEED_INFO_SIZE_V2) {
                        leadData.setRootId(leadData.getTransactionId());
                        LeadFeedData leadDataWithPerson = updateLeadFeedDataWithPersonInfo(leadData, leadConcat[4]);
                        leadDataWithMeta = updateLeadFeedDataWithMetadata(leadDataWithPerson, leadConcat[5], propensityScore);
                    }
                }


            }
            return leadDataWithMeta;
        } catch (SQLException | NamingException e) {
            LOGGER.error("[leadfeed] Problem when getting lead concat: {}", e.getMessage());
        }
        return leadData;
    }

    /**
     * Update lead feed data with meta data as required by `ctm-leads`
     * <p>
     * Note: do not throw any exception here.
     *
     * @param leadData
     * @param metadataJsonString
     * @param propensityScore
     */
    public LeadFeedData updateLeadFeedDataWithMetadata(LeadFeedData leadData, String metadataJsonString,
                                                       final String propensityScore) {
        if (StringUtils.isBlank(metadataJsonString)) {
            return leadData;
        }
        LOGGER.info("BANANA: " + metadataJsonString);
        CTMCarLeadFeedRequestMetadata metadata = new CTMCarLeadFeedRequestMetadata();
        try {
            final ObjectMapper mapper = new ObjectMapper();
            metadata = mapper.readValue(metadataJsonString, CTMCarLeadFeedRequestMetadata.class);
        } catch (IOException e) {
            e.printStackTrace();
        }

        metadata.setProviderQuoteRef(leadData.getPartnerReference());
        metadata.setProviderCode(leadData.getPartnerBrand());
        //propensity score could be null, DUPLICATE, double, string. `ctm-leads` is responsible for it to convert it to usable form.
        metadata.setPropensityScore(propensityScore);
        leadData.setMetadata(metadata);
        return leadData;
    }

    /**
     * Updates lead feed data with person as required by `ctm-leads`
     * <p>
     * Note: do not throw any exception here.
     *
     * @param leadData
     * @param personJsonString
     */
    public LeadFeedData updateLeadFeedDataWithPersonInfo(LeadFeedData leadData, String personJsonString) {

        if (StringUtils.isBlank(personJsonString)) {
            return leadData;
        }

        Person person = null;
        try {
            final ObjectMapper mapper = new ObjectMapper();
            person = mapper.readValue(personJsonString, Person.class);
        } catch (IOException e) {
            e.printStackTrace();
        }

        leadData.setPerson(person);
        return leadData;
    }
}
