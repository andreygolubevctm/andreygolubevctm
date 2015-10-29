package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.model.IsoLocations;
import com.ctm.web.core.dao.IsoLocationsDao;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

import static com.ctm.web.core.logging.LoggingArguments.kv;


public class IsoLocationsService {

    protected final IsoLocationsDao isoLocationsDao;

    public IsoLocationsService() {
        this.isoLocationsDao = new IsoLocationsDao();
    }

    private static final Logger LOGGER = LoggerFactory.getLogger(IsoLocationsService.class);

    public IsoLocationsService(IsoLocationsDao dao) {
        this.isoLocationsDao = dao;
    }

    public JSONObject fetchCountryList() throws DaoException {

        ArrayList<IsoLocations> countries = isoLocationsDao.getIsoLocations(null);
        JSONObject json = new JSONObject();

        try {
            json.put("isoLocations" , countries);
        } catch (JSONException e) {
            LOGGER.error("Failed creating json object {}", kv("countries", countries), e);
        }
        return json;
    }

    public JSONObject fetchSearchResults(String searchTerm) throws DaoException {

        IsoLocationsDao isoLocationsDao = new IsoLocationsDao();
        ArrayList<IsoLocations> isoLocations = isoLocationsDao.getIsoLocations(searchTerm);

        JSONObject json = new JSONObject();

        try {
            json.put("isoLocations" , isoLocations);
        } catch (JSONException e) {
            LOGGER.error("Failed creating json object {}", kv("isoLocations", isoLocations), e);
        }
        return json;
    }
}
