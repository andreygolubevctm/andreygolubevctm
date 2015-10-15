package com.ctm.router.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.health.form.HealthRegisterPaymentRequest;
import com.ctm.model.health.results.HealthPaymentResultWrapper;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.health.HealthRegisterPaymentService;
import org.apache.cxf.jaxrs.ext.MessageContext;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;

import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthRegisterPaymentRouter extends CommonQuoteRouter<HealthRegisterPaymentRequest> {

    private HealthRegisterPaymentService healthRegisterPaymentService = new HealthRegisterPaymentService();

    @POST
    @Path("/payment/register.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public HealthPaymentResultWrapper authorise(@Context MessageContext context, @FormParam("") final HealthRegisterPaymentRequest data) throws
            DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data);

        HealthPaymentResultWrapper wrapper = new HealthPaymentResultWrapper();
        wrapper.setResult(healthRegisterPaymentService.register(brand, data));

        return wrapper;
    }

}
