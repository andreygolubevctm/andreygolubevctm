package com.ctm.services.health;

import java.util.ArrayList;
import java.util.List;

import com.ctm.model.health.HealthPriceRequest;
import org.apache.log4j.Logger;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.health.HealthPriceResult;import com.ctm.model.health.ProductStatus;
public class HealthPriceResultsService {

	private static Logger logger = Logger.getLogger(HealthPriceResultsService.class.getName());

	private HealthPriceDao healthPriceDao;

	public HealthPriceResultsService() {
		this.healthPriceDao = new HealthPriceDao();
	}

	public HealthPriceResultsService(HealthPriceDao healthPriceDao) {
		this.healthPriceDao = healthPriceDao;
	}

	/**
	 * Fetch health products
	 * If it is a saved quote, also check if the price has changed
	 * check if needs to fetch additional single product and add to the result list
	 */
	public ArrayList<HealthPriceResult> fetchHealthResults(HealthPriceRequest healthPriceRequest) throws DaoException {

		ArrayList<HealthPriceResult> healthPriceResults = healthPriceDao.fetchHealthResults(healthPriceRequest);

		if (healthPriceRequest.getRetrieveSavedResults()) {
			checkPricesHaveChanged(healthPriceResults, healthPriceRequest);
		}

		String selectedProductId = healthPriceRequest.getSelectedProductId();

		// If loading a quote and unable to find the quote in simple check if online only
		// OR
		// if loading a quote from brochure edm then send user directly to application stage
		if ((healthPriceRequest.getIsSimples() || healthPriceRequest.isDirectApplication())
				&& selectedProductId != null && !selectedProductId.isEmpty()
				&& !isProductInResultsList(healthPriceResults, selectedProductId)) {

			logger.info("selectedProductId '" + selectedProductId + "' not found in results, need to fetch");

			List<ProductStatus> excludeStatus = new ArrayList<ProductStatus>();
			excludeStatus.add(ProductStatus.NOT_AVAILABLE);
			excludeStatus.add(ProductStatus.EXPIRED);
			healthPriceRequest.setExcludeStatus(excludeStatus);

			return fetchSingleHealthResult(healthPriceResults, healthPriceRequest);
		}

		return healthPriceResults;
	}

	/**
	 * Fetch single health product then add to the result list
	 */
	private ArrayList<HealthPriceResult> fetchSingleHealthResult(ArrayList<HealthPriceResult> healthPriceResults, HealthPriceRequest healthPriceRequest) throws DaoException {
		HealthPriceResult healthPriceResult = healthPriceDao.fetchSingleHealthResult(healthPriceRequest);
		if (healthPriceResult.getProductId() != null && !healthPriceResult.getProductId().isEmpty()) {
			healthPriceResults.add(healthPriceResult);
		}
		return healthPriceResults;
	}

	/**
	 * Fetch single health product for empty result list, e.g. in payment step
	 */
	public ArrayList<HealthPriceResult> fetchSingleHealthResult(HealthPriceRequest healthPriceRequest) throws DaoException {
		ArrayList<HealthPriceResult> healthPriceResults = new ArrayList<HealthPriceResult>();
		return fetchSingleHealthResult(healthPriceResults, healthPriceRequest);
	}

	/**
	 * Check if price has changed when retrieve quote
	 */
	private void checkPricesHaveChanged(ArrayList<HealthPriceResult> healthPriceResults, HealthPriceRequest healthPriceRequest) throws DaoException {

		ArrayList<HealthPriceResult> savedHealthResults = healthPriceDao.fetchSavedHealthResults(healthPriceRequest);

		for (HealthPriceResult savedHealthResult : savedHealthResults) {
			if (!savedHealthResult.isValid()) {
				healthPriceRequest.setPricesHaveChanged(true);
				break;
			} else if (!healthPriceResults.contains(savedHealthResult) && savedHealthResults.size() <= healthPriceRequest.getSearchResults()) {
				healthPriceRequest.setPricesHaveChanged(true);
				break;
			}
		}
	}

	/**
	 * Check if a given productId is in returned health price results list
	 */
	private boolean isProductInResultsList(ArrayList<HealthPriceResult> healthPriceResults, String productId) {

		boolean isProductInResultsList = false;

		for (HealthPriceResult healthPriceResult : healthPriceResults) {
			if (healthPriceResult.getProductId().equals(productId)) {
				isProductInResultsList = true;
				break;
			}
		}

		return isProductInResultsList;
	}



}
