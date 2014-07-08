package com.ctm.services.confirmation;

import java.net.URLEncoder;

import org.apache.log4j.Logger;

import com.ctm.dao.ConfirmationDao;
import com.ctm.dao.TransactionDao;
import com.ctm.model.Confirmation;
import com.ctm.model.TransactionProperties;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.SettingsService;

public class ConfirmationService {
	private static Logger logger = Logger.getLogger(ConfirmationService.class.getName());

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
						confirmationUrl.append("health_confirmation.jsp?action=confirmation");
						confirmationUrl.append("&token=").append(URLEncoder.encode(confirmationKey, "UTF-8"));
						break;
				}

				if(EnvironmentService.needsManuallyAddedBrandCodeParam()){
					confirmationUrl.append("&brandCode=").append(brand.getCode());
				}
			}
		}
		catch (Exception e) {
			logger.error(e);
		}

		return confirmationUrl.toString();
	}
}
