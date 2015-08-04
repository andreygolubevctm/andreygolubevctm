package com.ctm.router.health.simples;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.simples.VerintService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import static javax.servlet.http.HttpServletResponse.SC_NOT_FOUND;

@WebServlet(urlPatterns = {
        "/ajax/xml/pauseResumeCall"
})
public class PhoneRouter extends HttpServlet {

    private static final long serialVersionUID = 13L;
    private static final Logger logger = Logger.getLogger(PhoneRouter.class.getName());

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
     //Set content type based on extention
        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        } else {
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");
        }

        // Route the requests ///////////////////////////////////////////////////////////////////////////////
        try {
            if (uri.endsWith("ajax/xml/pauseResumeCall")) {
                verintService.pauseResumeRecording(request, response, SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH"));
            } else {
                response.sendError(SC_NOT_FOUND);
            }
        } catch (DaoException | ConfigSettingException e) {
            throw new ServletException(e.getMessage());
        }

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

    }

}