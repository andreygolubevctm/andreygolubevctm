package com.ctm.web.car.router;

import com.ctm.web.car.dao.CarRegoLookupDao;
import com.ctm.web.car.exceptions.RegoLookupException;
import com.ctm.web.car.services.RegoLookupService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.VerticalException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Stream;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@RestController
@RequestMapping("/rest/rego")
public class RegoLookupController {
    private static final Logger LOGGER = LoggerFactory.getLogger(RegoLookupController.class);

    private static final String COLLECTION_LABEL = "vehicle_data";
    /*
     allow only num 0 to 9 and all alpha chars and white space
     */
    private final String REG_EXP_FOR_PLATE = "[^0-9A-Za-z ]";

    @Autowired
    private RegoLookupService regoLookupService;

    @Autowired
    private CarRegoLookupDao carRegoLookupDao;

    @ApiOperation(value = "/lookup/list.json", notes = "Request a rego lookup", produces = "application/json")
    @RequestMapping(value = "/lookup/list.json",
            method= RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getRegolookup(@RequestParam("transactionId") Long transactionId,
                                             @RequestParam("plateNumber") String plateNumber,
                                             @RequestParam("state") String state,
                                             HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        String request_status = RegoLookupService.RegoLookupStatus.SUCCESS.getLabel();
        try {
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
                    regoLookupService.execute(request,
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
            carRegoLookupDao.logLookup(transactionId, plateNumber, state, request_status);
        } catch (DaoException e) {
            LOGGER.error("[rego lookup] Error logging car rego request {},{},{},{}", kv("transactionId", transactionId),
                    kv("plateNumber", plateNumber), kv("state", state), kv("request_status", request_status));
        }

        return result;
    }
}
