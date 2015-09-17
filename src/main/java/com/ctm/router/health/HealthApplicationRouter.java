package com.ctm.router.health;

import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;
import com.ctm.router.CommonQuoteRouter;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthApplicationRouter extends CommonQuoteRouter<HealthRequest> {

    @POST
    @Path("/apply/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("text/html")
    public HealthApplyResponse getHealthApply(@Context MessageContext context, @FormParam("") final HealthRequest data) {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data); // TODO check IP Address is correct





//        if (data == null || data.getQuote() == null) {
//            throw new RouterException("Data quote is missing");
//        }

//        HealthResult result = new HealthResult();
//        result.setSuccess(false);
////        result.setPolicyNo("XXXXXX");
//        result.setFund("HCF");
//        final Error error = new Error();
//        error.setCode("111");
//        error.setOriginal("111 original");
//        error.setText("111 text");
//        result.setErrors(Arrays.asList(error));
        // TODO: add implementation
        return null;


    }

}
