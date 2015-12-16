package com.ctm.web.health.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.health.model.form.HealthAuthorisePaymentRequest;
import com.ctm.web.health.model.results.HealthResultWrapper;
import com.ctm.web.health.services.HealthAuthorisePaymentService;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthAuthorisePaymentRouter extends CommonQuoteRouter<HealthAuthorisePaymentRequest> {

    public HealthAuthorisePaymentRouter(){
        applicationService = ApplicationService.getInstance();
        service = new SessionDataService();
    }


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
