package com.ctm.web.core.confirmation.services;

import com.ctm.web.core.confirmation.dao.ConfirmationDao;
import com.ctm.web.core.confirmation.model.Confirmation;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.TransactionProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.net.URLEncoder;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class ConfirmationService {
	private static final Logger LOGGER = LoggerFactory.getLogger(ConfirmationService.class);

	@Autowired
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
			LOGGER.error("Unable to get confirmation record {}, {}", kv("confirmationKey", confirmationKey), kv("brandId", brandId), e);
		}

		return confirmation;
	}

	/**
	 * Get confirmation record by the key and transaction id.
	 * @param confirmationKey
	 * @param transactionId
	 * @return
	 */
	public Optional<Confirmation> getConfirmationByKeyAndTransactionId(String confirmationKey, Long transactionId) {
		Optional<Confirmation> confirmation = Optional.empty();

		try {
			confirmation = confirmationDao.getByKey(confirmationKey, transactionId);
		}
		catch (DaoException e) {
			LOGGER.error("Unable to get confirmation record {}, {}", kv("confirmationKey", confirmationKey), kv("transactionId", transactionId), e);
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
						confirmationUrl.append(details.getVerticalCode());
						confirmationUrl.append("_confirmation.jsp?action=confirmation");
						confirmationUrl.append("&transactionId=" + details.getTransactionId());
						confirmationUrl.append("&token=").append(URLEncoder.encode(confirmationKey, "UTF-8"));
						break;
				}

				if(EnvironmentService.needsManuallyAddedBrandCodeParamWhiteLabel(brand.getCode(), details.getVerticalCode())){
					confirmationUrl.append("&brandCode=").append(brand.getCode());
				}
			}
		}
		catch (Exception e) {
			LOGGER.error("Unable to get confirmation url {}", kv("confirmationKey", confirmationKey), e);
		}

		return confirmationUrl.toString();
	}

	public void addConfirmation(final Confirmation confirmation) throws DaoException {
		confirmationDao.addConfirmation(confirmation);
	}
}
