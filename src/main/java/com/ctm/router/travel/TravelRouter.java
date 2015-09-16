package com.ctm.router.travel;

import com.ctm.model.resultsData.ResultsObj;
import com.ctm.model.resultsData.ResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.model.travel.form.TravelRequest;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.EnvironmentService;
import com.ctm.services.travel.TravelService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.util.List;

@Path("/travel")
public class TravelRouter extends CommonQuoteRouter<TravelRequest> {

	private static final Logger logger = LoggerFactory.getLogger(TravelRouter.class.getName());

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
    public ResultsWrapper getTravelQuote(@Context MessageContext context, @FormParam("") final TravelRequest data) throws Exception {

        Vertical.VerticalType vertical = Vertical.VerticalType.TRAVEL;

        // Initialise request
        Brand brand = initRouter(context, vertical);

        updateTransactionIdAndClientIP(context, data); // TODO check IP Address is correct

        checkIPAddressCount(brand, vertical, context);
        // Check IP Address Count

        TravelService travelService = new TravelService();
        travelService.validateRequest(data, vertical.getCode());

        // Get quotes

        List<TravelResult> travelQuoteResults = travelService.getQuotes(brand, data);

        // Build the JSON object for the front end.
        ResultsObj<TravelResult> results = new ResultsObj<>();
        results.setInfo(generateInfoKey(data, context));
        results.setResult(travelQuoteResults);

        return new ResultsWrapper(results);

    }




}
