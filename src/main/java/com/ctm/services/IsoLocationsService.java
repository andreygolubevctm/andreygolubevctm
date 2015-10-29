package com.ctm.services;

import com.ctm.web.core.dao.IsoLocationsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.IsoLocations;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

import static com.ctm.logging.LoggingArguments.kv;


public class IsoLocationsService {

    public IsoLocationsService() {
    }

	private static final Logger LOGGER = LoggerFactory.getLogger(IsoLocationsService.class);

    public JSONObject fetchCountryList() throws DaoException {

        IsoLocationsDao isoLocationsDao = new IsoLocationsDao();
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

    public JSONObject getCountrySelectionList() throws DaoException {
    	JSONObject countryList = fetchCountryList();
    	return addTopTenTravelDestinations(countryList);
    }

    public JSONObject addTopTenTravelDestinations(JSONObject json) throws DaoException {

        ArrayList<String> list = new ArrayList<String>();
        list.add("CHN");
        list.add("FJI");
        list.add("HKG");
        list.add("IDN");
        list.add("MYS");
        list.add("NZL");
        list.add("SGP");
        list.add("THA");
        list.add("GBR");
        list.add("USA");

        IsoLocationsDao isoLocationsDao = new IsoLocationsDao();
        ArrayList<IsoLocations> topTen = isoLocationsDao.getCountriesByIsoCodes(list);

        try {
            json.put("topTen" , topTen);
        } catch (JSONException e) {
            LOGGER.error("Failed creating json object {}", kv("topTen", topTen), e);
        }

        return json;

    }


}
