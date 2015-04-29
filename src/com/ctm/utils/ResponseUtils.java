package com.ctm.utils;

import com.ctm.services.FatalErrorService;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ResponseUtils {

    private static final Logger logger = Logger.getLogger(ResponseUtils.class.getName());

    public static void handleError(String uri, Exception exception, HttpServletResponse response , String message) {
        FatalErrorService fatalErrorService = new FatalErrorService();
        logger.error(message + " " + exception.getMessage(), exception);
        String sessionId = "";
        int styleCodeId = 0;
        fatalErrorService.logFatalError(exception, styleCodeId, uri , sessionId, true);
        com.ctm.model.Error error = new com.ctm.model.Error();
        error.addError(new com.ctm.model.Error(message));
        JSONObject json = error.toJsonObject(true);
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        try {
            response.getWriter().print(json.toString());
        } catch (IOException e) {
            logger.error(e);
        }
    }
}
