package com.ctm.web.car.leadfeed.services.CTM;

import com.ctm.energy.apply.model.request.application.address.State;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.leadService.model.LeadStatus;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.*;
import com.ctm.web.core.leadfeed.services.AGISLeadFeedService;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.validation.Valid;
import javax.validation.ValidationException;

import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.FAILURE;
import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.SUCCESS;

/**
 * processes car lead feeds, and sends it to `ctm-leads`.
 * <p>
 * Currently only supports BESTPRICE lead feeds.
 * <p>
 * Reference {@linkplain AGISLeadFeedService}
 */
public class CTMCarLeadFeedService implements IProviderLeadFeedService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CTMCarLeadFeedService.class);
    private static final String SECURE = "Secure"; //This is equal to `ctm`
    //TODO make this config
    private static final String CAMPAIGN_ID = "CAR_TestCampaign";

    /**
     * process car lead.
     * <p>
     * Currently only supports Car BestPrice leads for BUDD. {@linkplain com.ctm.web.car.leadfeed.services.CarLeadFeedService}
     *
     * @param leadType
     * @param leadData
     * @return
     * @throws LeadFeedException
     */
    @Override
    public LeadFeedService.LeadResponseStatus process(LeadFeedService.LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
        LOGGER.info("[lead feed] Start processing car best price lead.");

        LeadFeedService.LeadResponseStatus feedResponse = FAILURE;
        //Lead must be best price only
        if (leadType != LeadFeedService.LeadType.BEST_PRICE) return feedResponse;

        CTMCarBestPriceLeadFeedRequest request = null;
        try {
            request = buildCtmCarBestPriceLeadFeedRequest(leadData);
            validateRequest(request);
        } catch (Exception e) {
            LOGGER.error("[lead feed] Skipping lead feed. Reason: {}. Request: {}", e.getLocalizedMessage(), getJsonString(request), e);
            return feedResponse;
        }

        LOGGER.info("[lead feed] Sending car lead feed request to ctm-leads: {}", getJsonString(request));

        return SUCCESS;
    }

    /**
     * trigger all the validations annotated in {@linkplain CTMCarBestPriceLeadFeedRequest} and objects in it.
     * Also do other manual validations.
     *
     * @param request
     */
    private void validateRequest(@Valid CTMCarBestPriceLeadFeedRequest request) {
        if (!Person.hasValidMobileOrPhone(request.getPerson())) {
            throw new ValidationException("Invalid request. Must have valid phone or mobile");
        }
    }

    /**
     * Builds a best price lead feed request to be send to `ctm-leads`.
     *
     * @param leadData lead feed data to build the request from.
     * @return request
     * @throws IllegalArgumentException when leadData is null, has null person, address, metadata.
     */
    protected CTMCarBestPriceLeadFeedRequest buildCtmCarBestPriceLeadFeedRequest(LeadFeedData leadData) throws IllegalArgumentException {

        if (leadData == null) {
            throw new IllegalArgumentException("[lead feed] Invalid or Null leadData");
        }

        CTMCarBestPriceLeadFeedRequest request = new CTMCarBestPriceLeadFeedRequest();
        request.setBrandCode(leadData.getBrandCode());
        request.setClientIP(leadData.getClientIpAddress());
        //TODO verify this
        //request.setRootId(leadData.getr);
        request.setSource(SECURE);
        request.setStatus(LeadStatus.OPEN);
        request.setTrasactionId(leadData.getTransactionId());
        request.setVerticalType(VerticalType.findByCode(leadData.getVerticalCode()));

        final Person person = leadData.getPerson();


        if (person == null) {
            throw new IllegalArgumentException("[lead feed] Found null or invalid person in leadData");
        }

        final Person requestPerson = new Person();
        requestPerson.setFirstName(person.getFirstName());
        requestPerson.setLastName(person.getLastName());
        requestPerson.setDob(person.getDob());
        requestPerson.setEmail(person.getEmail());
        requestPerson.setMobile(person.getMobile());
        requestPerson.setPhone(person.getPhone());

        final Address address = new Address();

        if (address == null) {
            throw new IllegalArgumentException("[lead feed] Found null or invalid address in leadData");
        }

        address.setState(State.valueOf(leadData.getState()));
        address.setPostcode(person.getAddress().getPostcode());
        address.setSuburb(person.getAddress().getSuburb());
        requestPerson.setAddress(address);

        final CTMCarLeadFeedRequestMetadata metadata = (CTMCarLeadFeedRequestMetadata) leadData.getMetadata();

        if (metadata == null || metadata.getType() != CTMCarLeadFeedRequestMetadata.MetadataType.CAR) {
            throw new IllegalArgumentException("[lead feed] Found null or invalid metadata in leadData");
        }

        final CTMCarLeadFeedRequestMetadata requestMetadata = new CTMCarLeadFeedRequestMetadata();
        requestMetadata.setType(metadata.getType());
        requestMetadata.setAgeRestriction(metadata.getAgeRestriction());
        requestMetadata.setNcdRating(metadata.getNcdRating());
        requestMetadata.setPropensityScore(metadata.getPropensityScore());
        requestMetadata.setProviderCode(metadata.getProviderCode());
        requestMetadata.setProviderQuoteRef(metadata.getProviderQuoteRef());
        requestMetadata.setVehicleDescription(metadata.getVehicleDescription());

        request.setPerson(requestPerson);
        request.setMetadata(requestMetadata);
        return request;
    }

    //TODO move this to some util
    public static String getJsonString(final Object obj) {
        final ObjectMapper objectMapper = new ObjectMapper();
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            LOGGER.warn("Unable to parse object to json");
        }
        return null;
    }
}
