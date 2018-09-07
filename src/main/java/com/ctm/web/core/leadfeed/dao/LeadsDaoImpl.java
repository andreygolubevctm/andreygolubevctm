package com.ctm.web.core.leadfeed.dao;

import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.car.model.form.CarQuote;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadfeed.config.LeadsConfig;
import com.ctm.web.core.leadfeed.model.CTMCarLeadFeedRequestMetadata;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.model.Person;
import com.ctm.web.core.leadfeed.services.ActiveProvidersService;
import com.ctm.web.core.leadfeed.services.TransactionsService;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.leadfeed.LeadFeedRootTransaction;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.naming.NamingException;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Retrieve car leads of any lead type. Based on `BestPriceLeadsDao`, refactored to enabled generic lead retrieval and
 * for testing and future maintenance purposes.
 */
@Component
public class LeadsDaoImpl implements LeadsDao {

    private static final int FULLNAME_ELEMENT = 0;
    private static final int PHONENUMBER_ELEMENT = 1;
    private static final int IDENTIFIER_ELEMENT = 2;
    private static final int STATE_ELEMENT = 3;
    private static final int PERSON_ELEMENT = 4;
    private static final int METADATA_ELEMENT = 5;
    private static final Logger LOGGER = LoggerFactory.getLogger(BestPriceLeadsDao.class);
    private ArrayList<LeadFeedData> leads = null;
    private String activeLeadProviders = null;
    private Date serverDate = new Date();
    @Autowired
    private ActiveProvidersService activeProvidersService;
    @Autowired
    private VerticalsDao verticalDao;
    @Autowired
    private TransactionsService transactionsService;
    @Autowired
    private LeadsRepository leadsRepository;
    @Autowired
    private LeadsConfig config;

    /**
     * Get all basic transaction details and combine into grouped sets based on rootId, then aggregate into leads.
     * <p>
     * Requires that the vertical passed has providers set up for leads (see `setActiveLeadProviders()`).
     *
     * @param brandCodeId
     * @param verticalCode
     * @param minutes
     * @param serverDate
     * @return
     * @throws DaoException
     */
    public ArrayList<LeadFeedData> getLeads(int brandCodeId, String verticalCode, Integer minutes, Date serverDate) throws DaoException {
        leads = new ArrayList<>();
        this.serverDate = serverDate;
        if (verticalCode == null) {
            LOGGER.error("Failed to retrieve lead feed {}, {}, {}", kv("verticalCode", verticalCode), kv("brandCodeId", brandCodeId), kv("serverDate", serverDate));
            return leads;
        }
        setActiveLeadProviders(verticalCode, serverDate);

        if (activeLeadProviders == null) {
            LOGGER.error("Failed to retrieve any active lead feed providers {}, {}, {}", kv("verticalCode", verticalCode), kv("brandCodeId", brandCodeId), kv("serverDate", serverDate));
            return leads;
        }

        try {
            ResultSet rawTrans = leadsRepository.getRawTransactions(verticalCode, brandCodeId);
            transactionsService.addAllTransactions(rawTrans);
            ArrayList<LeadFeedRootTransaction> transactions = transactionsService.getTransactions();

            for (LeadFeedRootTransaction tran : transactions) {
                LeadFeedData leadData = processTransactionData(verticalCode, tran, brandCodeId);
                if (leadData != null) {
                    leads.add(leadData);
                }
            }
        } catch (SQLException | NamingException e) {
            LOGGER.error("Failed to get lead feed transactions {}, {}", kv("verticalCode", verticalCode), kv("minutes", minutes));
            throw new DaoException(e);
        } finally {
            leadsRepository.close();
        }

        return leads;
    }

    /**
     * Retrieve a Vertical instance based on the passed verticalCode and refer to ActiverProvidersService to retrieve
     * a pipe separated list of providers who may pass leads.
     *
     * @param verticalCode
     * @param serverDate
     * @throws DaoException
     */
    protected void setActiveLeadProviders(String verticalCode, Date serverDate) throws DaoException {
        Vertical vertical = verticalDao.getVerticalByCode(verticalCode);
        activeLeadProviders = activeProvidersService.getActiveProvidersString(vertical.getId(), serverDate);
    }

    /**
     * Simple getter to assist testing.
     *
     * @return
     */
    protected String getActiveLeadProviders() {
        return activeLeadProviders;
    }

    /**
     * For a given root transaction instance, retireve full data and build a LeadFeedData instance. Since aggregated data
     * comes in potentially multiple records (each record containing certain steps of a journey), we loop through until
     * we find a valid record containing all relevant data which is the most recent lead for a given identifier.
     * <p>
     * Use a Pair to track the lead and the partial continue criteria for the loop (true = still looking, false = done)
     *
     * @param verticalCode
     * @param tran
     * @param brandCodeId
     * @return
     * @throws SQLException
     * @throws DaoException
     * @throws NamingException
     */
    protected LeadFeedData processTransactionData(String verticalCode, LeadFeedRootTransaction tran, int brandCodeId) throws SQLException, DaoException, NamingException {
        Pair<LeadFeedData, Boolean> leadData = Pair.of(null, true);
        if (tran.getHasLeadFeed()) {
            return null;
        }
        ResultSet data = leadsRepository.getAggregateLeadData(tran, activeLeadProviders);
        while (data.next() && leadData.getRight()) {
            leadData = buildLead(verticalCode, leadData, data, tran, brandCodeId);
        }
        return leadData.getLeft();
    }

    /**
     * Convert a ResultSet containing data related to a single journey step into a LeadFeedData instance.
     * <p>
     * Validate that:
     * - the leadInfo has enough elements
     * - the leadInfo contains a value for phone number
     * - this is the most recent lead for a given identifier
     * <p>
     * Further, if the provider is defined to pass through to CTM callcentre, add some extra data - may nullify the lead
     * if identified as CTM callcentre, but is not valid as a CTM lead (i.e. doesn't have the correct details in leadInfo
     *
     * @param verticalCode
     * @param lead
     * @param data
     * @param tran
     * @param brandCodeId
     * @return
     * @throws SQLException
     * @throws DaoException
     */
    protected Pair<LeadFeedData, Boolean> buildLead(String verticalCode, Pair<LeadFeedData, Boolean> lead, ResultSet data, LeadFeedRootTransaction tran, int brandCodeId) throws SQLException, DaoException {
        Long transactionId = data.getLong("transactionId");
        Long rootId = tran.getId();
        String[] leadConcat = data.getString("leadInfo").split("\\|\\|", -1);

        // old leadfeedinfo will have 4 elements, and new once will have 6.
        if (leadConcat.length < CarQuote.LEAD_FEED_INFO_SIZE_V1) {
            return lead;
        }

        String identifier = null;
        String leadNumber = null;
        if (lead.getLeft() != null) {
            identifier = lead.getLeft().getIdentifier();
            leadNumber = lead.getLeft().getLeadNumber();
        }
        String curLeadNumber = data.getString("leadNo");
        String propensityScore = data.getString("propensityScore");
        String curIdentifier = leadConcat[IDENTIFIER_ELEMENT];
        String phoneNumber = leadConcat[PHONENUMBER_ELEMENT];
        String fullName = leadConcat[FULLNAME_ELEMENT];
        String state = leadConcat[STATE_ELEMENT];
        String brandCode = data.getString("brandCode");

        if (phoneNumber.isEmpty()) {
            LOGGER.debug("[Lead info] lead skipped as no optin for call {}, {}, {}, {}", kv("transactionId", transactionId), kv("brandCodeId", brandCodeId), kv("verticalCode", verticalCode), kv("serverDate", serverDate));
            return lead;
        }

        if (!(identifier == null || (curIdentifier.equals(identifier) && !curLeadNumber.equals(leadNumber)))) {
            return Pair.of(lead.getLeft(), false);
        }


        LeadFeedData leadData = new LeadFeedData();
        leadData.setLeadNumber(curLeadNumber);
        leadData.setIdentifier(curIdentifier);
        leadData.setEventDate(serverDate);
        leadData.setPartnerBrand(brandCode);
        leadData.setTransactionId(transactionId);
        leadData.setClientName(fullName);
        leadData.setPhoneNumber(phoneNumber);
        leadData.setPartnerBrand(brandCode);
        leadData.setPartnerReference(leadNumber);
        leadData.setState(state);
        leadData.setClientIpAddress(tran.getIpAddress());
        leadData.setProductId(data.getString("productId"));
        leadData.setMoreInfoProductCode(data.getString("moreInfoProductCode"));
        leadData.setFollowupIntended(data.getString("followupIntended"));

        Brand brand = ApplicationService.getBrandByCode(tran.getStyleCode());
        leadData.setBrandId(brand.getId());
        leadData.setBrandCode(brand.getCode());
        leadData.setVerticalCode(verticalCode);
        leadData.setVerticalId(brand.getVerticalByCode(verticalCode).getId());
        leadData.setLeadType(Touch.TouchType.findByCode(tran.getType()).getDescription());

        lead = Pair.of(leadData, true);
        if (!isCTMLead(leadData)) {
            return lead;
        }

        lead = Pair.of(updateToCTMLead(leadData, leadConcat, rootId, propensityScore, brandCodeId), true);
        return lead;

    }

    /**
     * Wrapper for a (semi) complex condition to aid readability and testability.
     * <p>
     * - the lead is for CAR
     * - the partner brand is configured as a CTM Callcentre brand (application).
     *
     * @param leadData
     * @return
     */
    protected Boolean isCTMLead(LeadFeedData leadData) {
        return (
                StringUtils.equalsIgnoreCase(
                        leadData.getVerticalCode(),
                        Vertical.VerticalType.CAR.toString()
                )
                        && config.getCtmPartners().contains(leadData.getPartnerBrand()));
    }

    /**
     * Add extra data to a LeadFeedData instance, or nullify if leadInfo is not long enough.
     *
     * @param leadData
     * @param leadConcat
     * @param rootId
     * @param propensityScore
     * @param brandCodeId
     * @return
     * @throws DaoException
     */
    protected LeadFeedData updateToCTMLead(LeadFeedData leadData, String[] leadConcat, Long rootId, String propensityScore, int brandCodeId) throws DaoException {
        if (!CTMLeadsEnabled(brandCodeId)) {
            return leadData;
        }
        if (leadConcat.length < CarQuote.LEAD_FEED_INFO_SIZE_V2) {
            LOGGER.error("[Lead info] lead info has invalid number of elements {}, {}, {}, {}, {}", kv("transactionId", leadData.getTransactionId()), kv("leadConcatLength", leadConcat.length), kv("brandCodeId", brandCodeId), kv("verticalCode", leadData.getVerticalCode()), kv("serverDate", serverDate));
            return null;
        }
        leadData.setRootId(rootId);

        leadData.setPerson(getPersonData(leadConcat[PERSON_ELEMENT]));
        leadData.setMetadata(getMetadata(leadData, leadConcat[METADATA_ELEMENT], propensityScore));

        return leadData;
    }

    /**
     * Map a json struct to a Person instance.
     *
     * @param personJson
     * @return
     */
    protected Person getPersonData(String personJson) {
        if (StringUtils.isBlank(personJson)) {
            return null;
        }
        try {
            final ObjectMapper mapper = new ObjectMapper();
            return mapper.readValue(personJson, Person.class);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Map a json struct to a CTMCarLeadFeedRequestMetadata instance.
     *
     * @param leadData
     * @param metadataJson
     * @param propensityScore
     * @return
     */
    protected CTMCarLeadFeedRequestMetadata getMetadata(LeadFeedData leadData, String metadataJson, final String propensityScore) {
        if (StringUtils.isBlank(metadataJson)) {
            return null;
        }
        LOGGER.info("BANANA: " + metadataJson);
        CTMCarLeadFeedRequestMetadata metadata = new CTMCarLeadFeedRequestMetadata();
        try {
            final ObjectMapper mapper = new ObjectMapper();
            metadata = mapper.readValue(metadataJson, CTMCarLeadFeedRequestMetadata.class);
        } catch (IOException e) {
            e.printStackTrace();
        }

        metadata.setProviderQuoteRef(leadData.getPartnerReference());
        metadata.setProviderCode(leadData.getPartnerBrand());
        //propensity score could be null, DUPLICATE, double, string. `ctm-leads` is responsible for it to convert it to usable form.
        metadata.setPropensityScore(propensityScore);
        return metadata;
    }


    /**
     * Check to see whether a CTM callcentre passing is actually enabled.
     *
     * @param brandCodeId
     * @return
     * @throws DaoException
     */
    protected Boolean CTMLeadsEnabled(int brandCodeId) throws DaoException {
        final ServiceConfiguration serviceConfig;
        try {
            serviceConfig = ServiceConfigurationService.getServiceConfiguration("leadService", CTMCarLeadFeedService.CAR_VERTICAL_ID);
        } catch (ServiceConfigurationException e) {
            LOGGER.error("[lead feed] Exception while reading service config. Message: {}", e.getMessage(), e);
            throw new DaoException(e.getMessage(), e);
        }

        return Boolean.valueOf(serviceConfig.getPropertyValueByKey("enabled", brandCodeId, 0, ServiceConfigurationProperty.Scope.SERVICE));
    }


}



