package com.ctm.utils;

import com.ctm.exceptions.SessionException;
import com.ctm.model.session.SessionData;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class RequestUtils {

    private static final Logger logger = Logger.getLogger(RequestUtils.class.getName());
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
        String requestTransactionId = request.getParameter("transactionId");
        if (requestTransactionId != null && !requestTransactionId.isEmpty()) {
            try{
                transactionId = Long.parseLong(requestTransactionId);
            } catch (NumberFormatException e) {
                logger.error("Failed to parse requestTransactionId:"+ requestTransactionId, e);
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
    public static void checkForTransactionIdInDataBucket(HttpServletRequest request) throws SessionException {
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
    private Data getData(HttpServletRequest request, long transactionId) throws SessionException {
        SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
        if (sessionData == null) {
            throw new SessionException("Session has Expired");
        }
        return sessionData.getSessionDataForTransactionId(transactionId);
    }

    /**
     * To make getData accessible via a static method.
     */
    public static Data getValidDataBucket(HttpServletRequest request, long transactionId) throws SessionException {
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
            if( type == Date.class && param != null){
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

}
