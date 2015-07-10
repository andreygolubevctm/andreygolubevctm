package com.ctm.router.car;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;

import com.ctm.exceptions.RegoLookupException;
import com.ctm.model.car.CarDetails;
import com.ctm.model.car.CarModel;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.car.CarVehicleSelectionService;
import com.ctm.services.car.RegoLookupService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Path("/rego")
public class RegoLookupRouter {
    private static Logger logger = Logger.getLogger(RegoLookupRouter.class.getName());

    private static final String COLLECTION_LABEL = "vehicle_data";

    @GET
    @Path("/lookup/list.json")
    @Produces("application/json")
    public Map<String, Object> getRegolookup(@Context MessageContext context, @QueryParam("plateNumber") String plateNumber, @QueryParam("state") String stateIn) {
        Map<String, Object> result = new HashMap<>();
        try {
            RegoLookupService regoLookupService = new RegoLookupService();
            HttpServletRequest request = context.getHttpServletRequest();
            ApplicationService.setVerticalCodeOnRequest(request, Vertical.VerticalType.CAR.getCode());
            Map<String, Object> carDetails = regoLookupService.execute(context.getHttpServletRequest(), plateNumber, stateIn);
            result.put(COLLECTION_LABEL, carDetails);
        } catch(RegoLookupException e) {
            Map<String, String> error = new LinkedHashMap<>();
            error.put("exception", e.getMessage());
            result.put(COLLECTION_LABEL, error);
        }
        return result;
    }
}
