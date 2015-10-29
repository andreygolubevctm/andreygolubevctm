package com.ctm.web.travel.services;

import com.ctm.exceptions.DaoException;
import com.ctm.model.IsoLocations;
import com.ctm.web.core.dao.IsoLocationsDao;
import com.ctm.web.core.services.IsoLocationsService;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

import static com.ctm.logging.LoggingArguments.kv;


public class TravelIsoLocationsService extends IsoLocationsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(IsoLocationsService.class);

    public TravelIsoLocationsService(IsoLocationsDao dao) {
        super(dao);
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

        List<IsoLocations> topTen = isoLocationsDao.getCountriesByIsoCodes(list);

        try {
            json.put("topTen" , topTen);
        } catch (JSONException e) {
            LOGGER.error("Failed creating json object {}", kv("topTen", topTen), e);
        }

        return json;

    }

    public JSONObject getCountrySelectionList() throws DaoException {
        JSONObject countryList = fetchCountryList();
        return addTopTenTravelDestinations(countryList);
    }
}
