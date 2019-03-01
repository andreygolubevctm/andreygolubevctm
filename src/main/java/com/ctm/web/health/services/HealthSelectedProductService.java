package com.ctm.web.health.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.health.dao.HealthSelectedProductDao;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.json.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import static com.ctm.commonlogging.common.LoggingArguments.kv;

import javax.annotation.Resource;
import javax.json.JsonArray;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

	/**
	 * getMinimalistProductXML strips excess content from the productXML (ie actually JSON).
	 * Presently is removes the benefits data from the custom, extras and hospital nodes.
	 *
	 * @param transactionId
	 * @param productId
	 * @return
	 * @throws DaoException
	 */
	public String getMinimalistProductXML(final long transactionId, final long productId) throws DaoException {
    	String productXML = getProductXML(transactionId, productId);
		return minimaliseProductXML(productXML);
	}

	public String minimaliseProductXML(String productXML) throws DaoException {
		try {
			ObjectMapper mapper = new ObjectMapper();
			JsonNode productJSON = mapper.readTree(productXML);
			if (productJSON != null) {
				JsonNode priceList = productJSON.path("price");
				if(priceList.isArray() && priceList.size() > 0) {
					// Remove additional product records. They sometimes exist due to a bug
					// but quicker to ensure they're removed here now and will resolve the
					// cause seperately. Confirmed 1st product is always the one we want.
					if(priceList.size() > 1) {
						for (int i = 1; i < priceList.size(); i++) {
							JsonNode price = priceList.get(i);
							List<String> props = new ArrayList<>();
							price.fields().forEachRemaining(entry -> {
								props.add(entry.getKey());
							});
							props.stream().forEach(x -> {
								((ObjectNode) price).remove(x);
							});
						}
					}
					JsonNode price = priceList.get(0);
					if (!price.isMissingNode()) {
						// Remove benefits lists from tab1 and tab2 nodes
						if (!price.path("custom").isMissingNode() && !price.path("custom").path("reform").isMissingNode()) {
							JsonNode reform = price.path("custom").path("reform");
							if (!reform.path("tab1").isMissingNode()) {
								if(!reform.path("tab1").path("benefits").isMissingNode()) {
									((ObjectNode) reform.path("tab1")).remove("benefits");
								}
							}
							if (!reform.path("tab2").isMissingNode()) {
								if(!reform.path("tab2").path("benefits").isMissingNode()) {
									((ObjectNode) reform.path("tab2")).remove("benefits");
								}
							}
						}
						// Remove benefits from hospital node
						JsonNode hospital = price.path("hospital");
						if (!hospital.isMissingNode()) {
							if(!hospital.path("benefits").isMissingNode()) {
								((ObjectNode) hospital).remove("benefits");
							}
						}
						// Removed benefits from extras node
						JsonNode extras = price.path("extras");
						if (!extras.isMissingNode()) {
							List<String> safeProps = new ArrayList<>();
							safeProps.add("ClassificationGeneralHealth");
							safeProps.add("PreferredProviderServices");
							List<String> benefits = new ArrayList<>();
							extras.fields().forEachRemaining(entry -> {
								if (!safeProps.contains(entry.getKey())) {
									benefits.add(entry.getKey());
								}
							});
							benefits.stream().forEach(x -> {
								((ObjectNode) extras).remove(x);
							});
						}
					}
				}
				productXML = productJSON.toString();
			}
		} catch (IOException e) {
			LOGGER.error("Exception minifying the productXML {} {}", kv("error",e.getMessage()), kv("productXML",productXML), e);
			throw new DaoException(e);
		}

		return productXML;
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