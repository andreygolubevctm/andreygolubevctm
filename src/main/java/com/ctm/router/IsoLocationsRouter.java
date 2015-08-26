package com.ctm.router;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.Error;
import com.ctm.services.FatalErrorService;
import com.ctm.services.IsoLocationsService;
import com.ctm.utils.RequestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
        "/isolocations/search.json",
        "/isolocations/countries.json",
        //"/isolocations/cities.json",
        //"/isolocations/regions.json",
        //"/isolocations/poi.json"
})
public class IsoLocationsRouter extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(IsoLocationsRouter.class.getName());
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
        IsoLocationsService isoLocations = new IsoLocationsService();

        if (uri.endsWith("/isolocations/search.json")) {
            String search = request.getParameter("search");

            if (search != null) {
                search = search.toLowerCase().trim() + "%";
            }

            JSONObject json = null;

            try {
                // added this instead as the RequestUtils call doesn't cater for when a session loss occurs
                response.setHeader("Access-Control-Allow-Origin", "*");
                json = isoLocations.fetchSearchResults(search);
            } catch (DaoException e) {

                logger.error("{}",e);
                FatalErrorService.logFatalError(e, 0, uri, request.getSession().getId(), true);

                Error error = new Error();
                error.addError(new Error(e.getMessage()));
                json = error.toJsonObject(true);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

            writer.print(json.toString());
        } else if (uri.endsWith("/isolocations/countries.json")) {

            JSONObject json = null;
            try {
                RequestUtils.checkForTransactionIdInDataBucket(request);
                json = isoLocations.fetchCountryList();
                if(request.getParameter("showTopTen") != null && request.getParameter("showTopTen").equals("true")) {
                    json = isoLocations.addTopTenTravelDestinations(json);
                }
            } catch (DaoException | SessionException e) {
                logger.error("{}",e);
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
