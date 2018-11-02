package com.ctm.web.health.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.health.dao.HealthSelectedProductDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * Class provides public accessors/modifiers to store product data in the database. Previously
 * this data had been stored in the user's session object.
 */

@Component
public class HealthSelectedProductService {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthSelectedProductService.class);

    @Resource
	private HealthSelectedProductDao selectedProductDao;

    public HealthSelectedProductService() {
        this.selectedProductDao = new HealthSelectedProductDao();
    }

	public HealthSelectedProductService(final long transactionId, final long productId, final String productXML) throws DaoException {
		this.selectedProductDao = new HealthSelectedProductDao();
		setProductXML(transactionId, productId, productXML);
	}

    public String getProductXML(final long transactionId, final long productId) throws DaoException {
        return selectedProductDao.getSelectedProduct(transactionId, productId);
    }

	public String getProductXML(final long transactionId) throws DaoException {
    	TransactionDetail detail = getProductIdFromTransactionDetails(transactionId);
		return detail != null ? selectedProductDao.getSelectedProduct(transactionId, Long.parseLong(detail.getTextValue().replaceAll("\\D",""))) : null;
	}

	// Cannot access overloaded methods from beans so distinct name required
	public String getProductXMLViaBean(final long transactionId) throws DaoException {
		return getProductXML(transactionId);
	}

    public void setProductXML(final long transactionId, final long productId, final String productXML) throws DaoException {
        selectedProductDao.addSelectedProduct(transactionId, productId, productXML);
    }

    private TransactionDetail getProductIdFromTransactionDetails(final long transactionId) throws DaoException {
		TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
		return transactionDetailsDao.getTransactionDetailByXpath(transactionId, "health/application/productId");
	}
}