package com.ctm.web.core.utils;

import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.exceptions.SessionExpiredException;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class RequestUtils {

    protected static final List<String> testIPAddresses = new ArrayList<String>() {
        private static final long serialVersionUID = 1L;

        {
            add("192.168.");
            add("202.177.206.");
            add("114.111.151.");
            add("202.189.67.");
        }};
   
    public static final String TRANSACTION_ID_PARAM = "transactionId";
    public static final String BRAND_CODE_PARAM = "brandCode";
    public static final String VERTICAL_PARAM = "vertical";
    public static final String VERIFICATION_TOKEN_PARAM = "verificationToken";

    private static final Logger LOGGER = LoggerFactory.getLogger(RequestUtils.class);

    private final SessionDataService sessionDataService = new SessionDataService();

    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public RequestUtils() {

    }

    /**
     * Get the transactionId from the request.
     * If String is not a number return -1
     * It is OK to retrieve the transactionId from the request, as we
     * check further on if its in the data bucket.
     */
    public static long getTransactionIdFromRequest(HttpServletRequest request) {
        long transactionId = -1L;
        String requestTransactionId = request.getParameter(TRANSACTION_ID_PARAM);
        if (requestTransactionId != null && !requestTransactionId.isEmpty()) {
            try{
                transactionId = Long.parseLong(requestTransactionId);
            } catch (NumberFormatException e) {
                LOGGER.error("Failed to parse transactionId from request. {}", kv("requestTransactionId", requestTransactionId), e);
            }
        }
        return transactionId;
    }

    /**
     * Determine whether the user has a transactionId in their request as a parameter and that it is in their data bucket.
     * If they don't, throw a SessionException
     * This is a security thing so people can't use our services without a valid session e.g. from the journey.
     * Caveat may be that a legitimate user may lose session between loading page and performing AJAX request.
     * @param request
     * @return
     */
    public static void checkForTransactionIdInDataBucket(HttpServletRequest request) throws SessionException, SessionExpiredException {
        String uri = request.getRequestURI();

        long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        String message = "[RequestUtils:checkForTransactionIdInDataBucket] ";

        if (transactionId < 1) {
            message += "No Transaction ID in request object";
        } else {
            Data data = getValidDataBucket(request, transactionId);
            if(data == null) {
                message += "TransactionID not found in data bucket";
            } else {
                return;
            }
        }
        message += " URI: " + uri + ", transactionId: " + transactionId;

        throw new SessionException(message);
    }

    /**
     * Retrieve the current sessions data bucket
     */
    private Data getData(HttpServletRequest request, long transactionId) throws SessionException, SessionExpiredException {
        SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
        if (sessionData == null) {
            throw new SessionExpiredException("Session has Expired");
        }
        return sessionData.getSessionDataForTransactionId(transactionId);
    }

    /**
     * To make getData accessible via a static method.
     */
    public static Data getValidDataBucket(HttpServletRequest request, long transactionId) throws SessionException, SessionExpiredException {
        RequestUtils utils = new RequestUtils();
        return utils.getData(request, transactionId);
    }

    public static <T extends Object> T createObjectFromRequest(HttpServletRequest request, T  object){
        Class<? extends Object> c = object.getClass();

        for (Method method : c.getMethods()) {
            String paramName = method.getName().replace("set", "");
            paramName = paramName.substring(0, 1).toLowerCase() + paramName.substring(1);
            String value = request.getParameter(paramName);
            if (method.getName().startsWith("set") && value != null) {
                callSetMethod(object, method, value);
            }
        }
        return object;
    }

    private static <T extends Object> void callSetMethod(T object, Method method, String value) {
        try {
             method.invoke(object, convertValue(method.getParameterTypes()[0], value));
        } catch (InvocationTargetException | IllegalAccessException | ParseException e) {}
    }

    private static Object convertValue(Class<?> type, String param) throws ParseException {
        Object value = null;
        try {
            if( type == LocalDate.class && param != null && !param.isEmpty()){
                value = LocalDate.parse(param, DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            } else if( type == Date.class && param != null){
                value = sdf.parse(param);
            }  else if( type == Integer.class){
                value =  !param.isEmpty() ? new Integer(param) : null;
            } else if( type == int.class ){
                value =  param != null && !param.isEmpty() ? Integer.parseInt(param) : 0;
            }else if( type == float.class  || type == Float.class){
                value =  Float.parseFloat(param);
            }else if( type == long.class  || type == Long.class){
                value =  Long.parseLong(param);
            }else {
                value =  param;
            }
        } catch(NumberFormatException ne){
            if(type!=null){
                throw new NumberFormatException("the type of " + type.getName()+"."+value +" is '"+ type.getName() + "' which is not suitable for value '"+value+"'");
            }
        }
        return value;
    }

    public static Vertical.VerticalType getVerticalFromRequest(ServletRequest request) {
        String verticalCode = request.getParameter(VERTICAL_PARAM);
        Vertical.VerticalType vertical = null;
        if(verticalCode != null) {
            vertical =  Vertical.VerticalType.findByCode(verticalCode);
        }
        return vertical;
    }


    public static String getTokenFromRequest(HttpServletRequest request) {
        return request.getParameter(VERIFICATION_TOKEN_PARAM);
    }

    public static boolean isTestIp(HttpServletRequest request) {
        return testIPAddresses.stream().anyMatch(testIPAddress -> request.getLocalAddr().startsWith(testIPAddress));
    }

}
