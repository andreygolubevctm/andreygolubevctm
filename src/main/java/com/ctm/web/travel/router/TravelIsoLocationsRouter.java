package com.ctm.web.travel.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.dao.IsoLocationsDao;
import com.ctm.web.core.router.IsoLocationsRouter;
import com.ctm.web.core.services.IsoLocationsService;
import com.ctm.web.travel.services.TravelIsoLocationsService;
import org.json.JSONObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * The idea of this class is to provide an interface for any vertical that requires
 * access to a list of countries, cities, places of interest, regions etc via an API call.
 * SearchDestination would search amongst countries, cities, places of interest etc.
 * Other calls may be required at different times, so examples have been provided for later use. *
 */
@WebServlet(urlPatterns = {
        "/isolocations/search.json",
        "/isolocations/countries.json"
})
public class TravelIsoLocationsRouter extends IsoLocationsRouter {

    private TravelIsoLocationsService isoLocationsService;
    private static final long serialVersionUID = 73L;

    public TravelIsoLocationsRouter(TravelIsoLocationsService service) {
        super(service);
        isoLocationsService = service;
    }

    public TravelIsoLocationsRouter() {
        super();
        this.isoLocationsService = new TravelIsoLocationsService(new IsoLocationsDao());
    }

    @Override
    protected IsoLocationsService getService(){
        return isoLocationsService;
    }

    public JSONObject fetchCountryList(HttpServletRequest request) throws DaoException {
        final String showTopTen = request.getParameter("showTopTen");
        JSONObject json = isoLocationsService.fetchCountryList();
        if(showTopTen != null && showTopTen.equals("true")) {
            json = isoLocationsService.addTopTenTravelDestinations(json);
        }
        return json;
    }
}