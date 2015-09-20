package com.ctm.services.confirmation;

import com.ctm.dao.ConfirmationDao;
import com.ctm.dao.transaction.TransactionDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Confirmation;
import com.ctm.model.TransactionProperties;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.SettingsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URLEncoder;

public class ConfirmationService {
	private static final Logger logger = LoggerFactory.getLogger(ConfirmationService.class.getName());

	private ConfirmationDao confirmationDao;

	public ConfirmationService() {
		this.confirmationDao = new ConfirmationDao();
	}

	/**
	 * Get confirmation record by the key with strict validation that the transaction is associated with the specified brand.
	 * @param confirmationKey
	 * @param brandId
	 * @return
	 */
	public Confirmation getConfirmationByKeyAndBrandId(String confirmationKey, int brandId) {
		Confirmation confirmation = null;

		try {

			confirmation = confirmationDao.getByKey(confirmationKey);

			if (confirmation.getTransactionId() > 0) {
				// Get the related transaction details (brand, vertical)
				TransactionDao transactionDao = new TransactionDao();
				TransactionProperties details = new TransactionProperties();

				details.setTransactionId(confirmation.getTransactionId());
				transactionDao.getCoreInformation(details);

				if (details.getStyleCodeId() != brandId) {
					// Invalid; brand IDs do not match
					confirmation = null;
				}
			}
			else {
				// Could not validate
				confirmation = null;
			}
		}
		catch (DaoException e) {
			logger.error(e.getMessage(), e);
		}

		return confirmation;
	}


	/**
	 * Create a URL for viewing a confirmation that is brand and vertical aware.
	 * @param confirmationKey
	 * @return confirmationUrl
	 */
	public String getViewConfirmationUrl(String confirmationKey) {
		StringBuilder confirmationUrl = new StringBuilder();

		ConfirmationDao confirmationDao = new ConfirmationDao();
		try {
			// Get the confirmation details
			Confirmation confirmation = confirmationDao.getByKey(confirmationKey);

			if (confirmation.getTransactionId() > 0) {
				// Get the related transaction details (brand, vertical)
				TransactionDao transactionDao = new TransactionDao();
				TransactionProperties details = new TransactionProperties();

				details.setTransactionId(confirmation.getTransactionId());
				transactionDao.getCoreInformation(details);

				// Get the relevant brand+vertical settings
				Brand brand = ApplicationService.getBrandById(details.getStyleCodeId());
				PageSettings settings = SettingsService.getPageSettings(details.getStyleCodeId(), details.getVerticalCode());
				String brandRootUrl = settings.getBaseUrl();

				confirmationUrl.append(brandRootUrl);

				switch (details.getVerticalCode()) {
					case "health":
					case "homeloan":
					case "utilities":
						confirmationUrl.append(details.getVerticalCode());
						confirmationUrl.append("_confirmation.jsp?action=confirmation");
						confirmationUrl.append("&transactionId=" + details.getTransactionId());
						confirmationUrl.append("&token=").append(URLEncoder.encode(confirmationKey, "UTF-8"));
						break;
				}

				if(EnvironmentService.needsManuallyAddedBrandCodeParam()){
					confirmationUrl.append("&brandCode=").append(brand.getCode());
				}
			}
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return confirmationUrl.toString();
	}

	public boolean addConfirmation(final Confirmation confirmation) throws DaoException {
		confirmationDao.addConfirmation(confirmation);
		return true;
	}
}
