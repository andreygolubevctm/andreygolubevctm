package com.ctm.router.travel;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RouterException;
import com.ctm.exceptions.SessionException;
import com.ctm.exceptions.TravelServiceException;
import com.ctm.model.Info;
import com.ctm.model.Results;
import com.ctm.model.ResultsWrapper;
import com.ctm.model.settings.*;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.services.*;
import com.ctm.services.tracking.TrackingKeyService;
import com.ctm.services.travel.TravelService;
import com.ctm.web.validation.SchemaValidationError;
import com.disc_au.web.go.Data;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServlet;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.List;

@Path("/travel")
public class TravelRouter extends HttpServlet {

    private static Logger logger = Logger.getLogger(TravelRouter.class.getName());

    private Brand initRouter(MessageContext context){
        // - Start common -- taken from Carlos' car branch
        ApplicationService.setVerticalCodeOnRequest(context.getHttpServletRequest(), Vertical.VerticalType.TRAVEL.getCode());
        Brand brand = null;
        try {
            brand = ApplicationService.getBrandFromRequest(context.getHttpServletRequest());

        } catch (DaoException e) {
            throw new RouterException(e);
        }
        return brand;
    }

    private String updateClientIP(MessageContext context, TravelRequest data){
        SessionDataService service = new SessionDataService();
        String clientIpAddress = null;
        try {
            logger.info("TRAN ID: "+data.getTransactionId());
            Data dataForTransactionId = service.getDataForTransactionId(context.getHttpServletRequest(), data.getTransactionId().toString(), true);
            // TODO CAN THIS HANDLE SESSION RECOVERY? ANSWER IS NO!
            data.setTransactionId(Long.parseLong(dataForTransactionId.getString("current/transactionId")));
            clientIpAddress = (String) dataForTransactionId.get("quote/clientIpAddress");
            if (StringUtils.isBlank(clientIpAddress)) {
                clientIpAddress = context.getHttpServletRequest().getRemoteAddr();
            }
            data.setClientIpAddress(clientIpAddress);
        } catch (DaoException | SessionException e) {
            throw new RouterException(e);
        }

        return clientIpAddress;
    }

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
                logger.error("Error in country mapping inport", e);
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
            Results<TravelResult> results = new Results<>();
            results.setInfo(info);
            results.setResult(travelQuoteResults);

            return new ResultsWrapper(results);

        }catch (TravelServiceException e){
            throw new RouterException(e);
        }


    }



}
