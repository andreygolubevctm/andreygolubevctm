package com.ctm.web.core.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.exceptions.SessionExpiredException;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.IsoLocationsService;
import com.ctm.web.core.utils.RequestUtils;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


/**
 * The idea of this class is to provide an interface for any vertical that requires
 * access to a list of countries, cities, places of interest, regions etc via an API call.
 * SearchDestination would search amongst countries, cities, places of interest etc.
 */
public abstract class IsoLocationsRouter extends HttpServlet {
    private static final Logger LOGGER = LoggerFactory.getLogger(IsoLocationsRouter.class);
    private static final long serialVersionUID = 73L;
    protected final IsoLocationsService service;

    public IsoLocationsRouter(IsoLocationsService service) {
        this.service = service;
    }

    public IsoLocationsRouter() {
        this.service = new IsoLocationsService();
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uri = request.getRequestURI();
        PrintWriter writer = response.getWriter();

        // Automatically set content type based on request extension ////////////////////////////////////////

        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        }

        // Route the requests ///////////////////////////////////////////////////////////////////////////////
        IsoLocationsService isoLocations = getService();

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
                LOGGER.error("Failed to fetch locations {}", kv("search", search),e);
                FatalErrorService.logFatalError(e, 0, uri, request.getSession().getId(), true);

                com.ctm.web.core.model.Error error = new Error();
                error.addError(new Error(e.getMessage()));
                json = error.toJsonObject(true);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }

            writer.print(json.toString());
        } else if (uri.endsWith("/isolocations/countries.json")) {
            JSONObject json = null;
            try {
                RequestUtils.checkForTransactionIdInDataBucket(request);
                json = fetchCountryList(request);
            } catch (DaoException | SessionException | SessionExpiredException e) {
                if(e instanceof SessionExpiredException) {
                    LOGGER.info(e.getMessage(), e);
                } else {
                    LOGGER.error("Failed to retrieve countries {}", kv("errorMessage", e.getMessage()));
                    FatalErrorService.logFatalError(e, 0, uri, request.getSession().getId(), true);
                }

                Error error = new Error();
                error.addError(new Error(e.getMessage()));
                json = error.toJsonObject(true);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
            writer.print(json.toString());
        }
    }

    protected abstract JSONObject fetchCountryList(HttpServletRequest request) throws DaoException;

    protected abstract IsoLocationsService getService();
}
