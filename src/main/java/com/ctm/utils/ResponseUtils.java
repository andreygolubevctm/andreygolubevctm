package com.ctm.utils;

import com.ctm.model.Error;
import com.ctm.services.FatalErrorService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Collection;

import static java.util.Arrays.asList;
import static javax.servlet.http.HttpServletResponse.SC_BAD_REQUEST;

public class ResponseUtils {

    private static final Logger logger = Logger.getLogger(ResponseUtils.class.getName());

    public static ObjectNode errors(final Exception e, ObjectMapper objectMapper) {
        return jsonObjectNode("errors", asList(new Error(e.getMessage())), objectMapper);
    }

    public static <T> ObjectNode jsonObjectNode(final String name, final T value,ObjectMapper objectMapper) {
        final ObjectNode objectNode = objectMapper.createObjectNode();
        objectNode.putPOJO(name, value);
        return objectNode;
    }

    public static void writeErrors(PrintWriter out, HttpServletResponse response, Collection errors) throws IOException {
        response.setStatus(SC_BAD_REQUEST);
        ObjectMapper objectMapper = getObjectMapper();
        objectMapper.writeValue(out, ResponseUtils.jsonObjectNode("error", errors, objectMapper));
    }

    public static void writeError(PrintWriter out,HttpServletResponse response, final Exception e) throws IOException {
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        ObjectMapper objectMapper = getObjectMapper();
        objectMapper.writeValue(out, errors(e, objectMapper));
    }

    public static void write(PrintWriter out, Object outcome) throws IOException {
       getObjectMapper().writeValue(out, outcome);
    }

    private static ObjectMapper getObjectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
        return objectMapper;
    }

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
