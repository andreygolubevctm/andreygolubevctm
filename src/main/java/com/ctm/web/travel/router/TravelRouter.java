package com.ctm.web.travel.router;

import com.ctm.exceptions.RouterException;
import com.ctm.web.travel.exceptions.TravelServiceException;
import com.ctm.model.resultsData.Info;
import com.ctm.model.resultsData.ResultsObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.travel.model.form.TravelRequest;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.EnvironmentService;
import com.ctm.services.IPCheckService;
import com.ctm.services.SettingsService;
import com.ctm.services.tracking.TrackingKeyService;
import com.ctm.web.travel.services.TravelService;
import com.ctm.web.core.web.validation.SchemaValidationError;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.List;

@Path("/travel")
public class TravelRouter extends CommonQuoteRouter<TravelRequest> {

    @GET
    @Path("/countrymapping/import")
    @Produces("application/text")
    public String doCountryMappingImport() {
        if(EnvironmentService.getEnvironment() == EnvironmentService.Environment.LOCALHOST || EnvironmentService.getEnvironment() == EnvironmentService.Environment.NXI)
        {
/*
            try {
                ProviderDao providerDao = new ProviderDao();
                UploadService uploadService = new UploadService();
                uploadService.uploadFile(request);

                Provider provider = providerDao.getProviderDetails(uploadService.getProviderCode(), "destMappingType");

                InputStream input = new ByteArrayInputStream(uploadService.importPartnerMapping(provider.getId(), provider.getPropertyDetail("mappingType")).getBytes("UTF-8"));

                response.setContentType("text/plain");
                response.addHeader("Content-Disposition", "attachment; filename=" + uploadService.getAttachmentName());

                return response.getOutputStream();
            } catch (Exception e) {
                LOGGER.error("Error in country mapping inport", e);
            }
            */
        }

        return "";

    }

    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper getTravelQuote(@Context MessageContext context, @FormParam("") final TravelRequest data) {

        String verticalCode = Vertical.VerticalType.TRAVEL.getCode();

        // Initialise request
        Brand brand = initRouter(context);
        updateClientIP(context, data); // TODO check IP Address is correct

        // Check IP Address Count
        IPCheckService ipCheckService = new IPCheckService();
        PageSettings pageSettings = SettingsService.getPageSettingsByCode(brand.getCode(), verticalCode);
        ipCheckService.isPermittedAccess(context.getHttpServletRequest(), pageSettings);

        // Validate request
        if (data == null) {
            throw new RouterException("Data quote is missing");
        }
        if(data.getQuote() == null){
            throw new RouterException("Data quote is missing (2)");
        }

        TravelService travelService = new TravelService();
        List<SchemaValidationError> errors = travelService.validateRequest(data, verticalCode);

        if(errors.size() > 0){
            throw new RouterException("Invalid request"); // TODO pass validation errors to client
        }

        // Get quotes
        try {
            List<TravelResult> travelQuoteResults = travelService.getQuotes(brand, verticalCode, data);


            // Generate the Tracking Key for Omniture tracking
            Info info = new Info();
            info.setTransactionId(data.getTransactionId());
            try {
                String trackingKey = TrackingKeyService.generate(
                        context.getHttpServletRequest(), new Long(data.getTransactionId()));
                info.setTrackingKey(trackingKey);
            } catch (Exception e) {
                throw new RouterException("Unable to generate the trackingKey for transactionId:" + data.getTransactionId(), e);
            }

            // Build the JSON object for the front end.
            ResultsObj<TravelResult> results = new ResultsObj<>();
            results.setInfo(info);
            results.setResult(travelQuoteResults);

            return new ResultsWrapper(results);

        } catch (TravelServiceException e){
            throw new RouterException(e);
        }
    }



}
