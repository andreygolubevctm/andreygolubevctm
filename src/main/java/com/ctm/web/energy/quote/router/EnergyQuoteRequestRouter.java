package com.ctm.web.energy.quote.router;


import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.services.EnergyResultsService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;


@Path("/energy")
public class EnergyQuoteRequestRouter extends CommonQuoteRouter<EnergyResultsWebRequest> {

    @Context
    private HttpServletRequest httpServletRequest;


    @Autowired
    EnergyResultsService energyResultsService;



    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ResultsWrapper quote(@Context MessageContext context, @FormParam("") final EnergyResultsWebRequest quoteRequest) throws IOException {
        Brand brand = initRouter(httpServletRequest);
        return energyResultsService.getResults(quoteRequest, brand);
    }

    @Override
    protected Vertical.VerticalType getVertical() {
        return Vertical.VerticalType.ENERGY;
    }
}
