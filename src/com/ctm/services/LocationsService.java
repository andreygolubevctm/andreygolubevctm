package com.ctm.services;

import com.ctm.dao.CountryMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.CountryMaster;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;


public class LocationsService {

    public LocationsService() {
    }

    private static Logger logger = Logger.getLogger(LocationsService.class.getName());

    public JSONObject fetchCountryList() throws DaoException {

        CountryMasterDao countryMasterDao = new CountryMasterDao();
        ArrayList<CountryMaster> countries = countryMasterDao.getCountries(null);
        JSONObject json = new JSONObject();

        try {
            json.put("countries" , countries);
        } catch (JSONException e) {
            logger.error(e);
        }
        return json;
    }

    public void fetchCityList(HttpServletRequest request) {

    }

    public void fetchPlacesOfInterestList() {

    }

    public JSONObject fetchSearchResults(String countryNameLike) throws DaoException {

        CountryMasterDao countryMasterDao = new CountryMasterDao();
        ArrayList<CountryMaster> countries = countryMasterDao.getCountries(countryNameLike);

        /*CityMasterDao cityMasterDao = new CityMasterDao();
        ArrayList<CityMaster> cities = cityMasterDao.getCities(search);*/

        JSONObject json = new JSONObject();

        try {
            json.put("countries" , countries);
            //For future searching:
            //json.put("cities" , cities);
            //json.put("poi" , poi);
            //json.put("regions" , regions);
        } catch (JSONException e) {
            logger.error(e);
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

        CountryMasterDao countryMasterDao = new CountryMasterDao();
        ArrayList<CountryMaster> topTen = countryMasterDao.getCountriesByIsoCodes(list);

        try {
            json.put("topTen" , topTen);
        } catch (JSONException e) {
            logger.error(e);
        }

        return json;

    }


}
