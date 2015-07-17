package com.ctm.services;

import com.ctm.dao.LmiDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.LmiModel;

import java.util.ArrayList;

/**
 * Created by bthompson on 26/06/2015.
 */
public class LmiService {

    LmiDao lmiDao;

    public LmiService() {
        this.lmiDao = new LmiDao();
    }

    public LmiService(LmiDao lmiDao) {
        this.lmiDao = lmiDao;
    }

    public ArrayList<LmiModel> getLmiBrands(String verticalType) {
        ArrayList<LmiModel> lmiModels = null;
        try {
            lmiModels = this.lmiDao.fetchProviders(verticalType);
        } catch (DaoException e) {
            e.printStackTrace();
        }
        return lmiModels;
    }
}
