package com.ctm.router.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.health.form.HealthAuthorisePaymentRequest;
import com.ctm.model.health.results.HealthResultWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.health.HealthAuthorisePaymentService;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthAuthorisePaymentRouter extends CommonQuoteRouter<HealthAuthorisePaymentRequest> {

    private final HealthAuthorisePaymentService healthPaymentService = new HealthAuthorisePaymentService();

    @POST
    @Path("/payment/authorise.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public HealthResultWrapper authorise(@Context MessageContext context, @FormParam("") final HealthAuthorisePaymentRequest data) throws
            DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);

        data.setReturnUrl(getPageSettingsByCode(brand, vertical).getBaseUrl());

        HealthResultWrapper wrapper = new HealthResultWrapper();
        wrapper.setResult(healthPaymentService.authorise(brand, data));

        return wrapper;
    }


}
