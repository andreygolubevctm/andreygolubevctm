package com.ctm.router.car;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;

import com.ctm.dao.car.CarRegoLookupDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.RegoLookupException;
import com.ctm.model.car.CarDetails;
import com.ctm.model.car.CarModel;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.car.CarVehicleSelectionService;
import com.ctm.services.car.RegoLookupService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import java.util.*;
import java.util.stream.Stream;

@Path("/rego")
public class RegoLookupRouter {
	private static final Logger logger = LoggerFactory.getLogger(RegoLookupRouter.class.getName());

    private static final String COLLECTION_LABEL = "vehicle_data";
    /*
     allow only num 0 to 9 and all alpha chars and white space
     */
    private final String REG_EXP_FOR_PLATE = "[^0-9A-Za-z ]";

    @GET
    @Path("/lookup/list.json")
    @Produces("application/json")
    public Map<String, Object> getRegolookup(@Context MessageContext context, @QueryParam("transactionId") Long transactionId, @QueryParam("plateNumber") String plateNumber, @QueryParam("state") String state) {
        Map<String, Object> result = new HashMap<>();
        String request_status = RegoLookupService.RegoLookupStatus.SUCCESS.getLabel();
        try {
            RegoLookupService regoLookupService = new RegoLookupService();
            HttpServletRequest request = context.getHttpServletRequest();
            ApplicationService.setVerticalCodeOnRequest(request, Vertical.VerticalType.CAR.getCode());
            Optional<String> plateOptional = Stream.of(plateNumber).map(String::toUpperCase).
                    map(s -> s.replaceAll(REG_EXP_FOR_PLATE,"")).
                    findFirst();
            Map<String, Object> carDetails = regoLookupService.execute(context.getHttpServletRequest(),
                                                                        plateOptional.orElse(""),state);
            result.put(COLLECTION_LABEL, carDetails);
        } catch(RegoLookupException e) {
            Map<String, String> error = new LinkedHashMap<>();
            error.put("exception", e.getMessage());
            result.put(COLLECTION_LABEL, error);
            request_status = e.getStatus().getLabel();
        }

        // Log the lookup attempt
        try {
            CarRegoLookupDao.logLookup(transactionId, plateNumber, state, request_status);
        } catch(DaoException e) {
            logger.error("[rego lookup] Error adding request to log: " + e.getMessage());
        }

        return result;
    }
}
