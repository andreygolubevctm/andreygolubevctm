package com.ctm.web.car.router;

import com.ctm.web.car.dao.CarRegoLookupDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.car.exceptions.RegoLookupException;
import com.ctm.exceptions.VerticalException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.web.car.services.RegoLookupService;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Stream;

import static com.ctm.web.core.logging.LoggingArguments.kv;

@Path("/rego")
public class RegoLookupRouter {
    private static final Logger LOGGER = LoggerFactory.getLogger(RegoLookupRouter.class);

    private static final String COLLECTION_LABEL = "vehicle_data";
    /*
     allow only num 0 to 9 and all alpha chars and white space
     */
    private final String REG_EXP_FOR_PLATE = "[^0-9A-Za-z ]";

    @GET
    @Path("/lookup/list.json")
    @Produces("application/json")
    public Map<String, Object> getRegolookup(@Context MessageContext context,
                                             @QueryParam("transactionId") Long transactionId,
                                             @QueryParam("plateNumber") String plateNumber,
                                             @QueryParam("state") String state) {
        Map<String, Object> result = new HashMap<>();
        String request_status = RegoLookupService.RegoLookupStatus.SUCCESS.getLabel();
        try {
            RegoLookupService regoLookupService = new RegoLookupService();
            HttpServletRequest request = context.getHttpServletRequest();
            ApplicationService.setVerticalCodeOnRequest(request, Vertical.VerticalType.CAR.getCode());
            Optional<String> plateOptional = Stream.of(plateNumber).map(String::toUpperCase).
                    map(s -> s.replaceAll(REG_EXP_FOR_PLATE, "")).
                    findFirst();
            PageSettings pageSettings;
            try {
                pageSettings = SettingsService.getPageSettingsForPage(request);
            } catch (DaoException | ConfigSettingException ex) {
                LOGGER.error("Failed to get pageSettings", ex);
                VerticalException vex = new VerticalException(ex.getMessage());
                vex.initCause(ex);
                throw vex;
            }

            Map<String, Object> carDetails =
                    regoLookupService.execute(context.getHttpServletRequest(),
                            pageSettings,
                            transactionId,
                            plateOptional.orElse(""), state);
            result.put(COLLECTION_LABEL, carDetails);
        } catch (RegoLookupException e) {
            Map<String, String> error = new LinkedHashMap<>();
            error.put("exception", e.getMessage());
            result.put(COLLECTION_LABEL, error);
            request_status = e.getStatus().getLabel();
        }

        // Log the lookup attempt
        try {
            CarRegoLookupDao.logLookup(transactionId, plateNumber, state, request_status);
        } catch (DaoException e) {
            LOGGER.error("[rego lookup] Error logging car rego request {},{},{},{}", kv("transactionId", transactionId),
                    kv("plateNumber", plateNumber), kv("state", state), kv("request_status", request_status));
        }

        return result;
    }
}
