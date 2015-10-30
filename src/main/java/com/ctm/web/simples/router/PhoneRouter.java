package com.ctm.web.simples.router;

import com.ctm.web.core.model.Error;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.services.VerintService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

@WebServlet(urlPatterns = {
        "/ajax/xml/pauseResumeCall.json"
})
public class PhoneRouter extends HttpServlet {

    @SuppressWarnings("UnusedDeclaration")
    public PhoneRouter() {
        this(new SessionDataService());
    }

    public PhoneRouter(SessionDataService sessionDataService) {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uri = request.getRequestURI();
        VerintService verintService = new VerintService();
        PrintWriter writer = response.getWriter();
     //Set content type based on extention
        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        } else {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
        }

        // Route the requests ///////////////////////////////////////////////////////////////////////////////
        try {
            if (uri.endsWith("ajax/xml/pauseResumeCall.json")) {
                writer.write(verintService.pauseResumeRecording(request, response, SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH")));
            } else {
                response.sendError(SC_NOT_FOUND);
            }
        } catch (Exception e) {
            writeErrors(e,writer,response);
        }

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

    }
    private void writeErrors(final Exception e, final PrintWriter writer, final HttpServletResponse response) {
        final Error error = new Error();
        error.addError(new Error(e.getMessage()));
        JSONObject json = error.toJsonObject(true);
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        writer.print(json.toString());
    }
}