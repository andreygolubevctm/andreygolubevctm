package com.ctm.web.car.leadfeed.services.CTM;

import com.ctm.energy.apply.model.request.application.address.State;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.leadService.model.LeadStatus;
import com.ctm.web.core.leadService.model.LeadType;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.*;
import com.ctm.web.core.leadfeed.services.AGISLeadFeedService;
import com.ctm.web.core.leadfeed.services.IProviderLeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import javax.validation.Valid;
import javax.validation.ValidationException;
import java.net.URI;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.FAILURE;
import static com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus.SUCCESS;

/**
 * processes car lead feeds, and sends it to `ctm-leads`.
 * (http://bitbucket.budgetdirect.com.au/projects/CTMSRV/repos/ctm-leads-project)
 * <p>
 * Reference {@linkplain AGISLeadFeedService}
 */
public class CTMCarLeadFeedService implements IProviderLeadFeedService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CTMCarLeadFeedService.class);
    private static final String SECURE = "Secure"; //This is equal to `ctm`
    private static final String BUDD = "BUDD";
    private static final String CAR = "CAR";
    public static final int CAR_VERTICAL_ID = 3;

    private String ctmLeadsUrl;
    private RestTemplate restTemplate;

    /**
     * unable to use @Autowired because of current design of {@linkplain com.ctm.web.car.leadfeed.services.CarLeadFeedService}
     * which calls new CTMCarLeadFeedService.
     */
    public CTMCarLeadFeedService(final String ctmLeadsUrl, final RestTemplate restTemplate) {
        this.ctmLeadsUrl = ctmLeadsUrl;
        this.restTemplate = restTemplate;
    }

    /**
     * process car lead.
     * <p>
     * Lead data passed in must be BUDD and comprehensive cover. The lead type from LeadFeedService will be converted to
     * a lead type recognised by ctm-leads. The lead data a relevant lead type are converted to a request object
     * which will be recognised by the ctm-leads service.
     *
     * @see this.buildCtmCarBestPriceLeadFeedRequest
     *
     * {@linkplain com.ctm.web.car.leadfeed.services.CarLeadFeedService}
     *
     * @param leadType
     * @param leadData
     * @return
     * @throws LeadFeedException
     */
    @Override
    public LeadFeedService.LeadResponseStatus process(LeadFeedService.LeadType leadType, LeadFeedData leadData) throws LeadFeedException {
        LOGGER.info("[lead feed] Start processing car best price lead.");

        //Lead must be car, best price, for BUDD only
        if (!org.apache.commons.lang3.StringUtils.equalsIgnoreCase(leadData.getPartnerBrand(), BUDD)
                || !org.apache.commons.lang3.StringUtils.equalsIgnoreCase(leadData.getVerticalCode(), CAR)) {
            LOGGER.error("Unable to process lead feed. Supported lead feeds are: CAR, BUDD (Budget Direct) ONLY. Invalid leadData: {}", getJsonString(leadData));
            return FAILURE;
        }

        CTMCarBestPriceLeadFeedRequest request = null;
        try {
            LeadType ctmLeadType = null;
            switch(leadType) {
                case BEST_PRICE: ctmLeadType = LeadType.BEST_PRICE; break;
                case CALL_DIRECT: ctmLeadType = LeadType.CALL_DIRECT; break;
                case CALL_ME_BACK: ctmLeadType = LeadType.CALL_ME_BACK; break;
                case NOSALE_CALL: ctmLeadType = LeadType.ONLINE_HANDOVER; break;
                case MORE_INFO: ctmLeadType = LeadType.MORE_INFO; break;
            }
            request = buildCtmCarBestPriceLeadFeedRequest(leadData, ctmLeadType);
            validateRequest(request);
        } catch (Exception e) {
            LOGGER.error("[lead feed] Exception while processing lead feed. Reason: {}. Request: {}", e.getLocalizedMessage(), getJsonString(request), e);
            return FAILURE;
        }

        return sendLeadFeedRequestToCtmLeads(request);
    }

    /**
     * Send a validly formatted lead request to the ctm-leads service.
     * @param request
     * @return
     */
    protected LeadFeedService.LeadResponseStatus sendLeadFeedRequestToCtmLeads(final CTMCarBestPriceLeadFeedRequest request) {
        LOGGER.info("[lead feed] Sending car lead feed request to ctm-leads: {}", getJsonString(request));

        final HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        final HttpEntity<List<CTMCarBestPriceLeadFeedRequest>> entity = new HttpEntity(request, headers);

        ResponseEntity<Object> responseEntity = null;
        try {
            responseEntity = restTemplate.postForEntity(URI.create(ctmLeadsUrl), entity, Object.class);
        } catch (HttpClientErrorException e){
            final String response = e.getResponseBodyAsString();
            LOGGER.error("[lead feed] Exception in response from ctm-leads. Reason: {}. Request: {}", response, getJsonString(request), e);
            return FAILURE;
        } catch (Exception e){
            LOGGER.error("[lead feed] Exception while sending lead feed. Reason: {}. Request: {}", e.getLocalizedMessage(), getJsonString(request), e);
            return FAILURE;
        }

        return Optional.ofNullable(responseEntity).map(response -> {
            LOGGER.info("Response from ctm-leads: {}", getJsonString(response.getBody()));
            return SUCCESS;

        }).orElseGet(() -> {
            LOGGER.error("Invalid or empty response from ctm-leads");
            return FAILURE;
        });
    }

    /**
     * trigger all the validations annotated in {@linkplain CTMCarBestPriceLeadFeedRequest} and objects in it.
     * Also do other manual validations.
     *
     * @param request
     */
    protected void validateRequest(@Valid CTMCarBestPriceLeadFeedRequest request) {
        if (!Person.hasValidMobileOrPhone(request.getPerson())) {
            throw new ValidationException("Invalid request. Must have valid phone or mobile");
        }
    }

    /**
     * Builds a lead feed request to be send to `ctm-leads`.
     *
     * @param leadData lead feed data to build the request from.
     * @return request
     * @throws IllegalArgumentException when leadData is null, has null person, address, metadata.
     */
    protected CTMCarBestPriceLeadFeedRequest buildCtmCarBestPriceLeadFeedRequest(LeadFeedData leadData, LeadType leadType) throws IllegalArgumentException {

        if (leadData == null) {
            throw new IllegalArgumentException("[lead feed] Invalid or Null leadData");
        }

        CTMCarBestPriceLeadFeedRequest request = new CTMCarBestPriceLeadFeedRequest();
        request.setBrandCode(leadData.getBrandCode());
        request.setClientIP(leadData.getClientIpAddress());
        request.setRootId(leadData.getRootId());
        request.setSource(SECURE);
        request.setStatus(LeadStatus.OPEN);
        request.setTransactionId(leadData.getTransactionId());
        request.setVerticalType(VerticalType.findByCode(leadData.getVerticalCode()));
        request.setLeadType(leadType);

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
