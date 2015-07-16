package com.ctm.services.travel;

import java.util.ArrayList;
import java.util.List;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.exceptions.TravelServiceException;
import com.ctm.model.AvailableType;
import com.ctm.model.results.ResultProperty;
import com.ctm.model.settings.*;
import com.ctm.model.travel.TravelResult;
import com.ctm.model.travel.form.TravelQuote;
import com.ctm.providers.Request;
import com.ctm.providers.travel.travelquote.model.RequestAdapter;
import com.ctm.providers.travel.travelquote.model.ResponseAdapter;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;
import com.ctm.services.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.jaxrs.json.JacksonJsonProvider;
import org.apache.cxf.jaxrs.client.WebClient;
import org.apache.log4j.Logger;

import com.ctm.web.validation.FormValidation;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import static java.util.Arrays.asList;

/**
 * TODO: once away from jsp create a router for this
 * @author adiente
 *
 */
public class TravelService {

	private static final Logger logger = Logger.getLogger(TravelService.class.getName());
	private boolean valid = false;
	private String vertical;
	private Data data;

	/**
	 * Used by JSP
	 *
	 * @return
	 */
	/*
    public String validateFields(HttpServletRequest request, Data data) {
        // TODO DEPRECATE
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request); // grab this current page's settings
			Vertical vert = pageSettings.getVertical(); // grab the vertical details
			vertical = vert.getType().toString().toLowerCase();

			RequestService fromFormService = new RequestService(request, vertical, data);
			SessionDataService sessionDataService = new SessionDataService();

			// remove anything that is not a numeric value and just let it continue as per normal. If they enter crap like bob, then they get bounced out of the A/B test
			String prefix = vertical.toLowerCase() + "/";
			String currentJourney = data.getString(prefix+"currentJourney");
			if (currentJourney != null)
			{
				// check if currentJourney contains any alpha characters
				Pattern p = Pattern.compile("[a-zA-Z]+");
				Matcher m = p.matcher(currentJourney);

				if (m.find()) {
					// empty our the currentJourney node if there is any alpha characters so we don't pollute the db with false currentJourney values
					// eg bob23 would be changed to ""
					data.put(prefix + "currentJourney", "");
				}
			}

			TravelRequest travelRequest = TravelRequestParser.parseRequest(data, vertical);
			List<SchemaValidationError> errors = validateRequest(travelRequest, vertical);

			if (!valid) {
				return outputErrors(fromFormService, errors);
			}
		}
		catch (Exception e) {
			logger.error(e);
		}
		return "";
	}
	*/


	public List<SchemaValidationError> validateRequest(com.ctm.model.travel.form.TravelRequest travelRequest, String vertical) {
		List<SchemaValidationError> errors = FormValidation.validate(travelRequest, vertical);
		valid = errors.isEmpty();
		return errors;
	}

	private String outputErrors(RequestService fromFormService, List<SchemaValidationError> errors) {
		String response;
		FormValidation.logErrors(fromFormService.sessionId, fromFormService.transactionId, fromFormService.styleCodeId, errors, "TravelService.java:validateRequest");
		response = FormValidation.outputToJson(fromFormService.transactionId, errors).toString();
		return response;
	}

    /**
     * Call travel-quote aggregation service.
     *
     * @param brand
     * @param verticalCode
     * @param data
     * @return
     */
    public List<TravelResult> getQuotes(Brand brand, String verticalCode, com.ctm.model.travel.form.TravelRequest data) throws TravelServiceException{

        // Get quote from Form Request
        final TravelQuote quote = data.getQuote();

        // Generate request object for Travel-quote aggregation service
        Request request = new Request();
        request.setBrandCode(brand.getCode());
        request.setClientIp(data.getClientIpAddress());
        request.setTransactionId(data.getTransactionId());

        // Convert posted data from form into a Travel-quote request
        final TravelQuoteRequest travelQuoteRequest = RequestAdapter.adapt(data);
        request.setPayload(travelQuoteRequest);

        // Prepare objectmapper to map java model to JSON
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);

        // Get URL of travel-quote service
        String serviceUrl = null;
        try {
            ServiceConfiguration serviceConfig = ServiceConfigurationService.getServiceConfiguration("carQuote", brand.getVerticalByCode(verticalCode).getId(), brand.getId());
            serviceUrl = serviceConfig.getPropertyValueByKey("serviceUrl", ConfigSetting.ALL_BRANDS, ServiceConfigurationProperty.ALL_PROVIDERS, ServiceConfigurationProperty.Scope.SERVICE);
        }catch (DaoException | ServiceConfigurationException e ){
            throw new TravelServiceException("TravelQuote config error", e);
        }

        // Connect to travel-quote
        final Response response = WebClient.create(serviceUrl, asList(new JacksonJsonProvider(objectMapper)))
                .path("quote")
                .type(MediaType.APPLICATION_JSON_TYPE)
                .accept(MediaType.APPLICATION_JSON_TYPE)
                .post(request);

        // Convert JSON response from travel-quote to java model
        final TravelResponse travelResponse = response.readEntity(TravelResponse.class);

        // Convert travel-quote java model to front end model ready for JSON conversion to the front end.
        final List<TravelResult> travelResults = ResponseAdapter.adapt(travelResponse);

        // Write to Results properties for EDM purposes
        LocalDate validUntil = new LocalDate().plusDays(30);

        DateTimeFormatter emailDateFormat = DateTimeFormat.forPattern("dd MMMMM yyyy");
        DateTimeFormatter normalFormat = DateTimeFormat.forPattern("yyyy-MM-dd");

        List<ResultProperty> resultProperties = new ArrayList<>();
        for (TravelResult result : travelResults) {
            if (AvailableType.Y.equals(result.getAvailable())) {

/*
                ResultPropertiesBuilder builder = new ResultPropertiesBuilder(request.getTransactionId(),
                        result.getProductId());

                builder.addResult("validateDate/display", emailDateFormat.print(validUntil))
                        .addResult("validateDate/normal", normalFormat.print(validUntil))
                        .addResult("productId", result.getProductId())
                        .addResult("productDes", result.getProviderProductName())
                        .addResult("excess/total", result.getExcess())
                        .addResult("headline/name", result.getProductName())
                        .addResult("quoteUrl", result.getQuoteUrl())
                        .addResult("telNo", result.getContact().getPhoneNumber())
                        .addResult("openingHours", result.getContact().getCallCentreHours())
                        .addResult("leadNo", result.getQuoteNumber())
                        .addResult("brandCode", result.getBrandCode());

                resultProperties.addAll(builder.getResultProperties());
                */
            }
        }

        ResultsService.saveResultsProperties(resultProperties);

        return travelResults;
    }



	public boolean isValid() {
		return valid;
	}

	public Data getGetData() {
		return data;
	}
}
