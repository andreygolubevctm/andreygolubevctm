package com.ctm.router.health;

import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.resultsData.ApplicationResultsWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.router.CommonQuoteRouter;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;

@Path("/health")
public class HealthApplicationRouter extends CommonQuoteRouter<HealthRequest> {

    @POST
    @Path("/apply/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public ApplicationResultsWrapper getHealthApply(@Context MessageContext context, @FormParam("") final HealthRequest data) {

        Vertical.VerticalType vertical = Vertical.VerticalType.HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data); // TODO check IP Address is correct


//        if (data == null || data.getQuote() == null) {
//            throw new RouterException("Data quote is missing");
//        }

        return null;


    }

}
