package com.ctm.web.car.services;

import au.com.motorweb.schemas.soap.autoid._1.*;
import au.com.motorweb.schemas.soap.autoid._1_0.AutoId;
import com.ctm.web.car.dao.CarColourDao;
import com.ctm.web.car.dao.CarRedbookDao;
import com.ctm.web.car.dao.CarRegoLookupDao;
import com.ctm.web.car.exceptions.RegoLookupException;
import com.ctm.web.car.model.CarDetails;
import com.ctm.web.car.model.MotorwebResponse;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.*;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.IPCheckService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.webservice.WebServiceUtils;
import com.ctm.webservice.motorweb.MotorWebProvider;
import org.apache.commons.lang3.StringUtils;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.frontend.ClientProxy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.webservice.motorweb.MotorWebProvider.createClient;

/**
 * Rego look up service
 * Calls MotorWeb's API with Registration Number and State
 * MotorWeb returns with a Redbook code
 *
 * This service can be turned off by a configuration setting
 * There are daily caps on the number of requests that can be made
 * Daily requests are limited by IP address
 */
@Component
public class RegoLookupService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RegoLookupService.class);

    private final String SERVICE_LABEL = "motorwebRegoLookupService";

    private static Map<String, JurisdictionEnum> FAKE_REGOS = createFakeRegos();

    private static Map<String, String> FAKE_REGOS_REDBOOK_LOOKUP = createRegoRedbookLookup();

    private static Map<String, JurisdictionEnum> createFakeRegos() {
        Map<String, JurisdictionEnum> fakeRegos = new LinkedHashMap<>();
        fakeRegos.put("YBO987", JurisdictionEnum.VIC);
        fakeRegos.put("1CG6FN", JurisdictionEnum.VIC);
        fakeRegos.put("1CJ2TZ", JurisdictionEnum.VIC);
        fakeRegos.put("ZGB395", JurisdictionEnum.VIC);
        fakeRegos.put("1BY1PV", JurisdictionEnum.VIC);
        fakeRegos.put("DEA848", JurisdictionEnum.NSW);
        fakeRegos.put("BU20HB", JurisdictionEnum.NSW);
        fakeRegos.put("CVF89M", JurisdictionEnum.NSW);
        fakeRegos.put("CTX48F", JurisdictionEnum.NSW);
        return fakeRegos;
    }

    private static Map<String, String> createRegoRedbookLookup() {
        Map<String, String> regoRedbookLookup = new LinkedHashMap<>();
        regoRedbookLookup.put("YBO987", "CHRY10AH");
        regoRedbookLookup.put("1CG6FN", "HOLD12EU");
        regoRedbookLookup.put("1CJ2TZ", "TOYO09CF");
        regoRedbookLookup.put("ZGB395", "TOYO12FK");
        regoRedbookLookup.put("1BY1PV", "TOYO08BL");
        regoRedbookLookup.put("DEA848", "MITS07IE");
        regoRedbookLookup.put("BU20HB", "FORD13AN");
        regoRedbookLookup.put("CVF89M", "NISS13BX");
        regoRedbookLookup.put("CTX48F", "FORD13DA");
        return regoRedbookLookup;
    }


    public static enum RegoLookupStatus {
        SUCCESS("success"),
        INVALID_STATE("invalid_state"),
        REGO_NOT_FOUND("rego_not_found"),
        SERVICE_ERROR("service_error"),
        DAO_ERROR("dao_error"),
        REQUEST_LIMIT_EXCEEDED("request_limit_exceeded"),
        DAILY_LIMIT_EXCEEDED("daily_limit_exceeded"),
        DAILY_LIMIT_UNDEFINED("daily_limit_undefined"),
        DAILY_USAGE_ERROR("daily_usage_error"),
        SERVICE_TURNED_OFF("service_turned_off"),
        SERVICE_TOGGLE_UNDEFINED("service_toggle_undefined"),
        TRANSACTION_UNVERIFIED("transaction_unverified"),
        NO_REDBOOK_CODE("no_redbook_code");

        private final String status;

        RegoLookupStatus(String status) {
            this.status = status;
        }

        public String getLabel() {
            return status;
        }
    };

    @Autowired
    private CarRegoLookupDao carRegoLookupDao;

    @Autowired
    private CarRedbookDao redbookDao;

    private Boolean serviceAvailable(HttpServletRequest request) throws RegoLookupException {
        return getServiceAvailable(request, false);
    }

    private Boolean getServiceAvailable(HttpServletRequest request, Boolean safeMode) throws RegoLookupException {
        Boolean isAvailable = false;
        try {
            if (safeMode || transactionVerified(request)) {
                LOGGER.debug("[rego lookup] transaction verified");
                if (isSwitchedOn(request)) {
                    LOGGER.debug("[rego lookup] is switched on");
                    if (withinDailyLimit(request)) {
                        LOGGER.debug("[rego lookup] is within daily limit");
                        if (!isIPBlocked(request)) {
                            LOGGER.info("[rego lookup] IP is not blocked");
                            isAvailable = true;
                        } else if (!safeMode) {
                            throw new RegoLookupException(RegoLookupStatus.REQUEST_LIMIT_EXCEEDED);
                        }
                    } else if (!safeMode) {
                        throw new RegoLookupException(RegoLookupStatus.DAILY_LIMIT_EXCEEDED);
                    }
                } else if (!safeMode) {
                    throw new RegoLookupException(RegoLookupStatus.SERVICE_TURNED_OFF);
                }
            }
        } catch(RegoLookupException e) {
            if (!safeMode) {
                throw new RegoLookupException(e.getStatus(), e);
            }
        }
        LOGGER.debug("[rego lookup] rego lookup service {}", kv("isAvailable", isAvailable));
        return isAvailable;
    }

    private Boolean transactionVerified(HttpServletRequest request) throws RegoLookupException {
        try {
            RequestUtils.checkForTransactionIdInDataBucket(request); // Will throw exception if fails
            return true;
        } catch(SessionException | SessionExpiredException e) {
            LOGGER.debug("[rego lookup] Error occurred verifying transaction {}", e);
            throw new RegoLookupException(RegoLookupStatus.TRANSACTION_UNVERIFIED, e);
        }
    }

    private Boolean isSwitchedOn(HttpServletRequest request) throws RegoLookupException {
        try {
            String available = ContentService.getContentValue(request, "regoLookupIsAvailable");
            return available != null && available.equalsIgnoreCase("Y");
        } catch(DaoException | ConfigSettingException e) {
            LOGGER.debug("[rego lookup] Error checking if rego lookup is enabled {}", e);
            throw new RegoLookupException(RegoLookupStatus.SERVICE_TOGGLE_UNDEFINED, e);
        }
    };

    private Boolean withinDailyLimit(HttpServletRequest request) throws RegoLookupException {
        final int dailyLimit;
        final int todaysUsage;

        try {
            todaysUsage = carRegoLookupDao.getTodaysUsage();
        } catch(DaoException e) {
            LOGGER.debug("[rego lookup] Error getting todays usage", e);
            throw new RegoLookupException(RegoLookupStatus.DAILY_USAGE_ERROR, e);
        }

        try {
            String dailyLimitStr = ContentService.getContentValue(request, "regoLookupDailyLimit");
            if(dailyLimitStr != null) {
                dailyLimit = Integer.parseInt(dailyLimitStr);
            } else {
                return false;
            }
        } catch(DaoException | ConfigSettingException e) {
            LOGGER.debug("[rego lookup] Error getting lookup daily limit", e);
            throw new RegoLookupException(RegoLookupStatus.DAILY_LIMIT_UNDEFINED, e);
        }

        return dailyLimit > todaysUsage;
    };

    private Boolean isIPBlocked(HttpServletRequest request) {
        Boolean isBlocked = true;
        IPCheckService ipService = new IPCheckService();
        if (ipService.isPermittedAccessAlt(request, Vertical.VerticalType.CAR)) {
            isBlocked = false;
        }
        return isBlocked;
    }

    public Map<String, Object> execute(HttpServletRequest request, PageSettings pageSettings,
                                       Long transactionId, String plateNumber, String stateIn) throws RegoLookupException {

        String motorwebNvic = null;
        String motorwebRedbook = null;

        Map<String, Object> response = null;

        if(serviceAvailable(request)) {
            // Lastly, check the postcode is valid and fail if not
            final JurisdictionEnum state;
            try {
                state = JurisdictionEnum.fromValue(stateIn);
            } catch (Exception e) {
                LOGGER.debug("[rego lookup] Error doing rego lookup {},{}", kv("stateIn", stateIn), e);
                logLookup(transactionId, plateNumber, stateIn, RegoLookupStatus.INVALID_STATE, motorwebNvic, motorwebRedbook);
                throw new RegoLookupException(RegoLookupStatus.INVALID_STATE, e);
            }

            final Optional<MotorwebResponse> motorwebResponse;

            try {
                // Step 1 - get the redbook code from MotorWeb
                motorwebResponse = getMotorwebResponse(pageSettings, transactionId, plateNumber, state);
                if (motorwebResponse != null){
                    motorwebNvic = motorwebResponse.map(MotorwebResponse::getNvicode).orElse(null);
                    motorwebRedbook = motorwebResponse.map(MotorwebResponse::getRedbookCode).orElse(null);
                }
            } catch (Exception e) {
                LOGGER.debug("[rego lookup] Error getting MotorWeb response {},{}", kv("plateNumber", plateNumber), kv("stateIn", stateIn), e);
                logLookup(transactionId, plateNumber, stateIn, RegoLookupStatus.SERVICE_ERROR, motorwebNvic, motorwebRedbook);
                throw new RegoLookupException(RegoLookupStatus.SERVICE_ERROR, e);
            }
            if (motorwebResponse == null || !motorwebResponse.isPresent()) {
                logLookup(transactionId, plateNumber, stateIn, RegoLookupStatus.REGO_NOT_FOUND, motorwebNvic, motorwebRedbook);
                throw new RegoLookupException(RegoLookupStatus.REGO_NOT_FOUND);
            } else if (StringUtils.isBlank(motorwebResponse.get().getRedbookCode())) {
                LOGGER.error("[rego lookup] No redbook code returned from Motorweb {}, {}", kv("plateNumber", plateNumber), kv("stateIn", stateIn));
                logLookup(transactionId, plateNumber, stateIn, RegoLookupStatus.NO_REDBOOK_CODE, motorwebNvic, motorwebRedbook);
                throw new RegoLookupException(RegoLookupStatus.NO_REDBOOK_CODE);
            } else {
                // Step 2 - get vehicle details from dao
                CarDetails carDetails = null;
                final MotorwebResponse res = motorwebResponse.get();
                try {
                    // Test regos don't return a valid redbookCode
                    if (isTestLookup(plateNumber, state)) {
                        carDetails = redbookDao.getCarDetails(getTestRedbookCode(plateNumber));
                    }
                    else {
                        carDetails = redbookDao.getCarDetails(res.getRedbookCode());
                    }

                    // set the colour
                    carDetails.setColour(new CarColourDao().getColourCode(res.getColourCode()));
                    carDetails.setNvicCode(res.getNvicode());

                    response = carDetails.getSimple();
                } catch (DaoException e) {
                    LOGGER.debug("[rego lookup] Error getting redbook car details {}", kv("plateNumber", plateNumber), kv("motorwebResponse", res), e);
                    logLookup(transactionId, plateNumber, stateIn, RegoLookupStatus.DAO_ERROR, motorwebNvic, motorwebRedbook);
                    throw new RegoLookupException(RegoLookupStatus.DAO_ERROR, e);
                }
                // Step 3 - get data for vehicle selection fields
                Map<String, Object> vehicleLists = CarVehicleSelectionService.getVehicleSelectionMap(
                        carDetails.getMake().getCode(),
                        carDetails.getModel().getCode(),
                        carDetails.getYear().getCode(),
                        carDetails.getBody().getCode(),
                        carDetails.getTransmission().getCode(),
                        carDetails.getFuel().getCode()
                );

                response.put("data", vehicleLists);
            }
        }

        logLookup(transactionId, plateNumber, stateIn, RegoLookupStatus.SUCCESS, motorwebNvic, motorwebRedbook);

        return response;
    }

    private void logLookup(Long transactionId, String plateNumber, String state, RegoLookupStatus status, String motorwebNvic, String motorwebRedbook){
        // Log the lookup attempt
        try {
            carRegoLookupDao.logLookup(transactionId, plateNumber, state, status.getLabel(), motorwebNvic, motorwebRedbook);
        } catch (DaoException e) {
            LOGGER.error("[rego lookup] Error logging car rego request {},{},{},{}", kv("transactionId", transactionId),
                    kv("plateNumber", plateNumber), kv("state", state), kv("request_status", status.getLabel()));
        }
    }

    private Optional<MotorwebResponse> getMotorwebResponse(PageSettings pageSettings, Long transactionId, String plateNumber,
                                                 JurisdictionEnum state) throws RegoLookupException {
        ServiceConfiguration serviceConfig;
        try {
            serviceConfig = ServiceConfigurationService.getServiceConfiguration("motorwebRegoLookupService", 0);
        } catch (DaoException | ServiceConfigurationException e) {
            LOGGER.debug("[rego lookup] Error getting motorweb rego serviceConfig {}", e);
            throw new RegoLookupException("Could not load the required configuration for the " + SERVICE_LABEL + " service", e);
        }

        try {

            String certificate = serviceConfig.getPropertyValueByKey("certificate", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);

            InputStream certificateFile;

            if(certificate.contains("WEB-INF/classes")){
                // Read certificate from WAR (test envs)
                certificate = certificate.replace("WEB-INF/classes", "");
                certificateFile =  getClass().getResourceAsStream(certificate);
            }else{
                // Read certificate from file system (should be Prod only)
                certificateFile =  new FileInputStream(certificate);
            }

            if(certificateFile == null){
                throw new RegoLookupException("MotorWeb Certificate not found: "+certificate);
            }

            String url = serviceConfig.getPropertyValueByKey("serviceUrl", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);
            String password = serviceConfig.getPropertyValueByKey("password", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);

            AutoId client = createClient(url, certificateFile, password);
            Client clientProxy = ClientProxy.getClient(client);

            // Setup logging
            WebServiceUtils.setLogging(clientProxy, pageSettings, transactionId, "REGO_LOOKUP");

            AutoIdRequest autoIdRequest = new AutoIdRequest();
            PlateType plateType = new PlateType();
            plateType.setPlateNumber(plateNumber);
            plateType.setStateCode(state);
            autoIdRequest.setPlate(plateType);
            AutoIdResponse autoIdResponse = client.autoId(autoIdRequest);
            if(autoIdResponse.getError() == null) {
                return autoIdResponse.getAutoreport().getVehicle().stream()
                        .findFirst()
                        .map(this::createMotorwebResponse);
            } else {
                LOGGER.debug("[rego lookup] Error motorweb response {},{}", kv("errorCode", autoIdResponse.getError().getCode()),
                    kv("errorValue", autoIdResponse.getError().getValue()));
                return null;
            }
        } catch (Exception e) {
            throw new RegoLookupException(e.getMessage(), e);
        }
    }

    private MotorwebResponse createMotorwebResponse(Vehicle v) {
        return new MotorwebResponse(v.getRedbookCode(), v.getNvicCode(),
                getColour(v.getColour()));
    }

    private String getColour(Vehicle.Colour colour) {
        return Optional.ofNullable(colour.getPrimary())
                .map(this::mapColour)
                .orElse("other");
    }

    private String mapColour(Vehicle.Colour.Primary primary) {
        if (primary.getCode() != null) {
            switch (primary.getCode()) {
                case BE: return "beige";
                case BK: return "black";
                case BL: return "blue";
                case BZ: return "bronze";
                case BR: return "brown";
                case CR: return "cream";
                case FA: return "fawn";
                case GO: return "gold";
                case GN: return "green";
                case GR: return "grey";
                case KH: return "khaki";
                case MN: return "maroon";
                case MA: return "mauve";
                case OR: return "orange";
                case PI: return "pink";
                case PU: return "purple";
                case RE: return "red";
                case SI: return "silver";
                case TA: return "tan";
                case TU: return "turquoise";
                case WH: return "white";
                case YE: return "yellow";
                default:
                    return null;
            }
        } else {
            return primary.getValue();
        }
    }

    private Boolean isTestLookup(String plateNumber, JurisdictionEnum state) {
        return FAKE_REGOS.containsKey(plateNumber) && FAKE_REGOS.get(plateNumber) == state;
    }

    private String getTestRedbookCode(String plateNumber) {
        return FAKE_REGOS_REDBOOK_LOOKUP.getOrDefault(plateNumber, "TOYO14BC");
    }
}
