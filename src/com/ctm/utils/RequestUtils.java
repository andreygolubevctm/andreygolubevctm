package com.ctm.utils;

import com.ctm.exceptions.SessionException;
import com.ctm.model.session.SessionData;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;
import org.apache.log4j.Logger;
import java.lang.reflect.Method;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public class RequestUtils {

    private static final Logger logger = Logger.getLogger(RequestUtils.class.getName());
    private final SessionDataService sessionDataService = new SessionDataService();

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
        Class<?> type =null;
        String paramName = "";
        String paramValue ="";
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            try {
                paramName = entry.getKey();
                Method method;
                type = object.getClass().getField(paramName).getType();
                Object value = null;
                paramValue = entry.getValue()!=null?entry.getValue()[0].trim():"";
                method = object.getClass().getMethod("set" + paramName.substring(0,1).toUpperCase()+  paramName.substring(1), type);
                if( type == int.class || type == Integer.class){
                    value =  Integer.parseInt(entry.getValue()!=null?entry.getValue()[0].trim():"0");
                }else if( type == float.class  || type == Float.class){
                    value =  Float.parseFloat(entry.getValue()!=null?entry.getValue()[0].trim():"0");
                }else if( type == long.class  || type == Long.class){
                    value =  Long.parseLong(entry.getValue()!=null?entry.getValue()[0].trim():"0");
                }else {
                    value =  entry.getValue()!=null?entry.getValue()[0].trim():null;
                }
                method.invoke(object,value);
            }catch(NumberFormatException ne){
                if(type!=null){
                    throw new NumberFormatException("the type of " +object.getClass().getName()+"."+paramName +" is '"+ type.getName() + "' which is not suitable for value '"+paramValue+"'");
                }
            }catch (ReflectiveOperationException e) {
                //not important to catch
            }
        }
        return object;
    }
}
