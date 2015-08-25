package com.ctm.services;

import com.ctm.dao.IsoLocationsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.IsoLocations;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


public class IsoLocationsService {

    public IsoLocationsService() {
    }

	private static final Logger logger = LoggerFactory.getLogger(IsoLocationsService.class.getName());

    public JSONObject fetchCountryList() throws DaoException {

        IsoLocationsDao isoLocationsDao = new IsoLocationsDao();
        ArrayList<IsoLocations> countries = isoLocationsDao.getIsoLocations(null);
        JSONObject json = new JSONObject();

        try {
            json.put("isoLocations" , countries);
        } catch (JSONException e) {
            logger.error("{}",e);
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
            logger.error("{}",e);
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
            logger.error("{}",e);
        }

        return json;

    }


}
