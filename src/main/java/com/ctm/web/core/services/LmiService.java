package com.ctm.web.core.services;

import com.ctm.web.core.dao.LmiDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.LmiModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Created by bthompson on 26/06/2015.
 */
public class LmiService {
    private static final Logger LOGGER = LoggerFactory.getLogger(LmiService.class);

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
            LOGGER.error("Failed to retrieve LMI {}", kv("verticalType", verticalType), e);
        }
        return lmiModels;
    }
}
