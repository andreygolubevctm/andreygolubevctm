package com.ctm.router;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.Error;
import com.ctm.services.FatalErrorService;
import com.ctm.services.LocationsService;
import com.ctm.utils.RequestUtils;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


/**
 * The idea of this class is to provide an interface for any vertical that requires
 * access to a list of countries, cities, places of interest, regions etc via an API call.
 * SearchDestination would search amongst countries, cities, places of interest etc.
 * Other calls may be required at different times, so examples have been provided for later use. *
 */
@WebServlet(urlPatterns = {
        "/locations/search.json",
        "/locations/countries.json",
        //"/locations/cities.json",
        //"/locations/regions.json",
        //"/locations/poi.json"
})
public class LocationsRouter extends HttpServlet {
    private static Logger logger = Logger.getLogger(LogRouter.class.getName());
    private static final long serialVersionUID = 73L;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uri = request.getRequestURI();
        PrintWriter writer = response.getWriter();

        // Automatically set content type based on request extension ////////////////////////////////////////

        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        }

        // Route the requests ///////////////////////////////////////////////////////////////////////////////
        LocationsService locations = new LocationsService();

        if (uri.endsWith("/locations/search.json")) {
            String search = request.getParameter("search");

            if (search != null) {
                search = search.toLowerCase() + "%";
            }

            JSONObject json = null;

            try {
                RequestUtils.checkForTransactionIdInDataBucket(request);
                json = locations.fetchSearchResults(search);
            } catch (DaoException | SessionException e) {

                logger.error(e);
                FatalErrorService.logFatalError(e, 0, uri, request.getSession().getId(), true);

                Error error = new Error();
                error.addError(new Error(e.getMessage()));
                json = error.toJsonObject(true);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

            writer.print(json.toString());
        } else if (uri.endsWith("/locations/countries.json")) {

            JSONObject json = null;
            try {
                RequestUtils.checkForTransactionIdInDataBucket(request);
                json = locations.fetchCountryList();
                if(request.getParameter("showTopTen") != null && request.getParameter("showTopTen").equals("true")) {
                    json = locations.addTopTenTravelDestinations(json);
                }
            } catch (DaoException | SessionException e) {
                logger.error(e);
                FatalErrorService.logFatalError(e, 0, uri, request.getSession().getId(), true);

                Error error = new Error();
                error.addError(new Error(e.getMessage()));
                json = error.toJsonObject(true);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            writer.print(json.toString());
        }
    }
}
