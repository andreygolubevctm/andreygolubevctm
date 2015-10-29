package com.ctm.web.car.services;

import au.com.motorweb.schemas.soap.autoid._1.*;
import au.com.motorweb.schemas.soap.autoid._1_0.AutoId;
import com.ctm.web.car.dao.CarRedbookDao;
import com.ctm.web.car.dao.CarRegoLookupDao;
import com.ctm.exceptions.*;
import com.ctm.web.car.model.CarDetails;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ContentService;
import com.ctm.services.IPCheckService;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.utils.RequestUtils;
import com.ctm.web.car.exceptions.RegoLookupException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.webservice.WebServiceUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.cxf.endpoint.Client;
import org.apache.cxf.frontend.ClientProxy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.LinkedHashMap;
import java.util.Map;

import static com.ctm.web.core.logging.LoggingArguments.kv;
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
public class RegoLookupService {

	private static final Logger LOGGER = LoggerFactory.getLogger(RegoLookupService.class);

    // Used to cache results of availability tests in serviceAvailableSilent method
    // as it's called multiple times when rendering frontend copy
    private static Boolean isServiceAvailable = null;

    final String SERVICE_LABEL = "motorwebRegoLookupService";

    private static ObjectMapper objectMapper = new ObjectMapper();


    public static enum RegoLookupStatus{
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
        TRANSACTION_UNVERIFIED("transaction_unverified");

        private final String status;

        RegoLookupStatus(String status) {
            this.status = status;
        }

        public String getLabel() {
            return status;
        }
    };

    static public Boolean serviceAvailable(HttpServletRequest request) throws RegoLookupException {
        return getServiceAvailable(request, false);
    }

    static public Boolean serviceAvailableSilent(HttpServletRequest request) throws RegoLookupException {
        if(isServiceAvailable == null) {
            isServiceAvailable = getServiceAvailable(request, true);
        } else {
            LOGGER.debug("[rego lookup] cached service availability returned");
        }
        return isServiceAvailable;
    }

    static private Boolean getServiceAvailable(HttpServletRequest request, Boolean safeMode) throws RegoLookupException {
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

    static private Boolean transactionVerified(HttpServletRequest request) throws RegoLookupException {
        Boolean verified = false;
        try {
            RequestUtils.checkForTransactionIdInDataBucket(request); // Will throw exception if fails
            verified = true;
        } catch(SessionException e) {
            LOGGER.debug("[rego lookup] Error occurred verifying transaction {}", e);
            throw new RegoLookupException(RegoLookupStatus.TRANSACTION_UNVERIFIED, e);
        }
        return verified;
    }

    static private Boolean isSwitchedOn(HttpServletRequest request) throws RegoLookupException {
        try {
            String available = ContentService.getContentValue(request, "regoLookupIsAvailable");
            return available != null && available.equalsIgnoreCase("Y");
        } catch(DaoException | ConfigSettingException e) {
            LOGGER.debug("[rego lookup] Error checking if rego lookup is enabled {}", e);
            throw new RegoLookupException(RegoLookupStatus.SERVICE_TOGGLE_UNDEFINED, e);
        }
    };

    static private Boolean withinDailyLimit(HttpServletRequest request) throws RegoLookupException {
        int dailyLimit = 0;
        int todaysUsage = 0;

        try {
            todaysUsage = CarRegoLookupDao.getTodaysUsage();
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

    static private Boolean isIPBlocked(HttpServletRequest request) {
        Boolean isBlocked = true;
        IPCheckService ipService = new IPCheckService();
        if (ipService.isPermittedAccessAlt(request, Vertical.VerticalType.CAR)) {
            isBlocked = false;
        }
        return isBlocked;
    }

    public Map<String, Object> execute(HttpServletRequest request, PageSettings pageSettings,
                                       Long transactionId, String plateNumber, String stateIn) throws RegoLookupException {

        Map<String, Object> response = null;

        if(serviceAvailable(request)) {
            // Lastly, check the postcode is valid and fail if not
            JurisdictionEnum state = null;
            try {
                state = JurisdictionEnum.fromValue(stateIn);
            } catch (Exception e) {
                LOGGER.debug("[rego lookup] Error doing rego lookup {},{}", kv("stateIn", stateIn), e);
                throw new RegoLookupException(RegoLookupStatus.INVALID_STATE, e);
            }

            String redbookCode = null;

            try {
                // Step 1 - get the redbook code from MotorWeb
                redbookCode = getRedbookCode(pageSettings, transactionId, plateNumber, state);
            } catch (Exception e) {
                LOGGER.debug("[rego lookup] Error geting redbook code {},{}", kv("plateNumber", plateNumber), kv("stateIn", stateIn), e);
                throw new RegoLookupException(RegoLookupStatus.SERVICE_ERROR, e);
            }
            if (redbookCode == null || redbookCode.isEmpty()) {
                throw new RegoLookupException(RegoLookupStatus.REGO_NOT_FOUND);
            } else {
                // Step 2 - get vehicle details from dao
                CarRedbookDao redbookDao = new CarRedbookDao();
                CarDetails carDetails = null;
                try {
                    // Test regos don't return a valid redbookCode
                    if (isTestLookup(plateNumber, state)) {
                        carDetails = redbookDao.getCarDetails("TOYO14BC");
                    }
                    else {
                        carDetails = redbookDao.getCarDetails(redbookCode);
                    }
                    response = carDetails.getSimple();
                } catch (DaoException e) {
                    LOGGER.debug("[rego lookup] Error getting redbook car details {}", kv("plateNumber", plateNumber), kv("redbookCode", redbookCode), e);
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
        return response;
    }

    private String getRedbookCode(PageSettings pageSettings, Long transactionId, String plateNumber,
                                  JurisdictionEnum state) throws RegoLookupException {
        ServiceConfiguration serviceConfig;
        try {
            serviceConfig = ServiceConfigurationService.getServiceConfiguration("motorwebRegoLookupService", 0, 0);
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
                return autoIdResponse.getAutoreport().getVehicle().get(0).getRedbookCode();
            } else {
                LOGGER.debug("[rego lookup] Error motorweb response {},{}", kv("errorCode", autoIdResponse.getError().getCode()),
                    kv("errorValue", autoIdResponse.getError().getValue()));
                return null;
            }
        } catch (Exception e) {
            throw new RegoLookupException(e.getMessage(), e);
        }
    }

    private Boolean isTestLookup(String plateNumber, JurisdictionEnum state) {
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
        return fakeRegos.containsKey(plateNumber) && fakeRegos.get(plateNumber) == state;
    }
}
