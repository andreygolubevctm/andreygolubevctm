package com.ctm.web.health.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.dao.HealthSelectedProductDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HealthSelectedProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthSelectedProductService.class);

    private final HealthSelectedProductDao selectedProductDao;

    public HealthSelectedProductService() {
        this.selectedProductDao = new HealthSelectedProductDao();
    }

	public HealthSelectedProductService(final long transactionId, final String productXML) throws DaoException {
		this.selectedProductDao = new HealthSelectedProductDao();
		setProductXML(transactionId, productXML);
	}

    public String getProductXML(final long transactionId) throws DaoException {
        return selectedProductDao.getSelectedProduct(transactionId);
    }

    public void setProductXML(final long transactionId, final String productXML) throws DaoException {
        selectedProductDao.addSelectedProduct(transactionId, productXML);
    }
}