package com.ctm.web.energy.quote.router;


import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.energy.form.model.EnergyResultsWebRequest;
import com.ctm.web.energy.form.response.model.EnergyResultsWebResponse;
import com.ctm.web.energy.services.EnergyResultsService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.springframework.beans.factory.annotation.Autowired;

import javax.jws.WebService;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;


@WebService
public class EnergyQuoteRouter extends CommonQuoteRouter<EnergyResultsWebRequest> {


    public EnergyQuoteRouter(){

    }

    @Autowired
    EnergyResultsService energyResultsService;


    @POST
    @Path("/quote/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("application/json")
    public EnergyResultsWebResponse quote(@Context MessageContext context, @FormParam("")
    final EnergyResultsWebRequest quoteRequest) throws IOException, ServiceConfigurationException, DaoException {
        Brand brand = initRouter(context, Vertical.VerticalType.ENERGY);
        return energyResultsService.getResults(quoteRequest, brand);
    }

/*    @PostConstruct
    public void init() {
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }*/

}
