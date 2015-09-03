package com.ctm.services;

import com.ctm.dao.LmiDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.LmiModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

/**
 * Created by bthompson on 26/06/2015.
 */
public class LmiService {
    private static final Logger logger = LoggerFactory.getLogger(LmiService.class.getName());

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
            logger.error("Failed to retrieve LMI", e);
        }
        return lmiModels;
    }
}
