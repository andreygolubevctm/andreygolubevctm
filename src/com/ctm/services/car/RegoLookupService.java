package com.ctm.services.car;

import au.com.motorweb.schemas.soap.autoid._1.AutoIdRequest;
import au.com.motorweb.schemas.soap.autoid._1.AutoIdResponse;
import au.com.motorweb.schemas.soap.autoid._1.JurisdictionEnum;
import au.com.motorweb.schemas.soap.autoid._1.PlateType;
import au.com.motorweb.schemas.soap.autoid._1_0.AutoId;
import com.ctm.dao.car.CarRedbookDao;
import com.ctm.dao.car.CarRegoLookupDao;
import com.ctm.exceptions.*;
import com.ctm.model.car.CarDetails;
import com.ctm.model.settings.ServiceConfiguration;
import com.ctm.model.settings.ServiceConfigurationProperty;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ContentService;
import com.ctm.services.IPCheckService;
import com.ctm.services.ServiceConfigurationService;
import com.ctm.services.SessionDataService;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.log4j.Logger;
import static com.ctm.webservice.motorweb.MotorWebProvider.createClient;
import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Created by msmerdon on 28/05/2015.
 */
public class RegoLookupService {

    private static Logger logger = Logger.getLogger(RegoLookupService.class.getName());

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

    static public Boolean isAvailable(HttpServletRequest request) throws RegoLookupException {
        try {
            String available = ContentService.getContentValue(request, "regoLookupIsAvailable");
            if(available != null && available.equalsIgnoreCase("Y")) {
                return true;
            } else {
                return false;
            }
        } catch(DaoException | ConfigSettingException e) {
            logger.debug("[rego lookup] Exception: " + e.getMessage());
            throw new RegoLookupException(RegoLookupStatus.SERVICE_TOGGLE_UNDEFINED, e);
        }
    };

    static public Boolean withinDailyLimit(HttpServletRequest request) throws RegoLookupException {
        int dailyLimit = 0;
        int todaysUsage = 0;

        try {
            todaysUsage = CarRegoLookupDao.getTodaysUsage();
        } catch(DaoException e) {
            logger.debug("[rego lookup] Exception: " + e.getMessage());
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
            logger.debug("[rego lookup] Exception: " + e.getMessage());
            throw new RegoLookupException(RegoLookupStatus.DAILY_LIMIT_UNDEFINED, e);
        }

        return dailyLimit > todaysUsage;
    };

    public Map<String, Object> execute(HttpServletRequest request, String plateNumber, String stateIn) throws RegoLookupException {

        // First, verify the transactionid with the session
        try {
            RequestUtils.checkForTransactionIdInDataBucket(request);
        } catch(SessionException e) {
            throw new RegoLookupException(RegoLookupStatus.TRANSACTION_UNVERIFIED, e);
        }

        // Secondly, check service is turned on
        if (isAvailable(request)) {
            // Thirdly, check the daily limit is not exceeded
            if (withinDailyLimit(request)) {
                // Fourthly, check IP request limit not exceeded
                IPCheckService ipService = new IPCheckService();
                if (ipService.isPermittedAccessAlt(request, Vertical.VerticalType.CAR)) {
                    // Lastly, check the postcode is valid and fail if not
                    JurisdictionEnum state = null;
                    try {
                        state = JurisdictionEnum.fromValue(stateIn);
                    } catch (Exception e) {
                        logger.debug("[rego lookup] Exception: " + e.getMessage());
                        throw new RegoLookupException(RegoLookupStatus.INVALID_STATE, e);
                    }

                    String redbookCode = null;

                    try {
                        // Step 1 - get the redbook code from MotorWeb
                        redbookCode = getRedbookCode(plateNumber, state);
                    } catch (Exception e) {
                        logger.debug("[rego lookup] Exception: " + e.getMessage());
                        throw new RegoLookupException(RegoLookupStatus.SERVICE_ERROR, e);
                    }
                    if (redbookCode == null) {
                        throw new RegoLookupException(RegoLookupStatus.REGO_NOT_FOUND);
                    } else {
                        // Step 2 - get vehicle details from dao
                        CarRedbookDao redbookDao = new CarRedbookDao();
                        CarDetails carDetails = null;
                        Map<String, Object> carDetailsJSON = null;
                        try {
                            if (isTestLookup(plateNumber, state)) {
                                // Test regos don't return a valid redbookCode
                                carDetails = redbookDao.getCarDetails("TOYO14BC");
                            } else {
                                carDetails = redbookDao.getCarDetails(redbookCode);
                            }
                            carDetailsJSON = carDetails.getSimple();
                        } catch (DaoException e) {
                            logger.debug("[rego lookup] Exception: " + e.getMessage());
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

                        carDetailsJSON.put("data", vehicleLists);

                        return carDetailsJSON;
                    }
                } else {
                    throw new RegoLookupException(RegoLookupStatus.REQUEST_LIMIT_EXCEEDED);
                }
            } else {
                throw new RegoLookupException(RegoLookupStatus.DAILY_LIMIT_EXCEEDED);
            }
        } else {
            throw new RegoLookupException(RegoLookupStatus.SERVICE_TURNED_OFF);
        }
    }

    private String getRedbookCode(String plateNumber, JurisdictionEnum state) throws RegoLookupException {
        ServiceConfiguration serviceConfig = null;
        try {
            serviceConfig = ServiceConfigurationService.getServiceConfiguration("motorwebRegoLookupService", 0, 0);
        } catch (DaoException | ServiceConfigurationException e) {
            logger.debug("[rego lookup] Exception: " + e.getMessage());
            throw new RegoLookupException("Could not load the required configuration for the " + SERVICE_LABEL + " service", e);
        }

        try {
            String url = serviceConfig.getPropertyValueByKey("serviceUrl", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);
            String password = serviceConfig.getPropertyValueByKey("password", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);
            String certificate = serviceConfig.getPropertyValueByKey("certificate", 0, 0, ServiceConfigurationProperty.Scope.SERVICE);
            AutoId client = createClient(url, getClass().getResourceAsStream(certificate), password);

            AutoIdRequest autoIdRequest = new AutoIdRequest();
            PlateType plateType = new PlateType();
            plateType.setPlateNumber(plateNumber);
            plateType.setStateCode(state);
            autoIdRequest.setPlate(plateType);
            AutoIdResponse autoIdResponse = client.autoId(autoIdRequest);
            if(autoIdResponse.getError() == null) {
                return autoIdResponse.getAutoreport().getVehicle().get(0).getRedbookCode();
            } else {
                logger.debug("[rego lookup] Error in response: (" + autoIdResponse.getError().getCode() + ") " + autoIdResponse.getError().getValue());
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
