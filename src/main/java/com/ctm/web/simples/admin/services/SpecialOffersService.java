package com.ctm.web.simples.admin.services;

import com.ctm.web.simples.admin.dao.SpecialOffersDao;
import com.ctm.web.core.dao.transaction.TransactionDetailsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.helper.SpecialOffersHelper;
import com.ctm.model.SpecialOffers;
import com.ctm.model.TransactionDetail;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.web.health.services.HealthPriceService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.validation.SchemaValidationError;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.List;

public class SpecialOffersService {

	private final SpecialOffersDao specialOffersDao = new SpecialOffersDao();
	private final SpecialOffersHelper specialOffersHelper = new SpecialOffersHelper();
	public SpecialOffersService() {
	}

	public List<SpecialOffers> getAllOffers()  {
		try {
			List<SpecialOffers> specialOffers;
			specialOffers = specialOffersDao.fetchSpecialOffers( 0);
			return specialOffers;
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}

	} 
	
	public List<SchemaValidationError> validateSpecialOffersData(HttpServletRequest request){
		try {
			SpecialOffers specialOffers = new SpecialOffers();
			specialOffers = RequestUtils.createObjectFromRequest(request, specialOffers);
			return specialOffersHelper.validateSpecialOffersRowData(specialOffers);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}
	
	public SpecialOffers updateSpecialOffers(HttpServletRequest request,AuthenticatedData authenticatedData)  {
		try {
			SpecialOffers specialOffers = new SpecialOffers();
			final String ipAddress = request.getRemoteAddr();
			specialOffers = RequestUtils.createObjectFromRequest(request, specialOffers);
			final String userName = authenticatedData.getUid();
			return specialOffersDao.updateSpecialOffers(specialOffers,userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public SpecialOffers createSpecialOffers(HttpServletRequest request,AuthenticatedData authenticatedData){
		try {
			SpecialOffers specialOffers = new SpecialOffers();
			specialOffers = RequestUtils.createObjectFromRequest(request, specialOffers);
			final String userName = authenticatedData.getUid();
			final String ipAddress = request.getRemoteAddr();
			
			return specialOffersDao.createSpecialOffers(specialOffers,userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}

	public List<SpecialOffers> getSpecialOffers(int providerId, int styleCodeId, Date applicationDate,
												HealthPriceService healthPriceService) throws DaoException {
		PageSettings pageSettings = SettingsService.getPageSettings(styleCodeId, "HEALTH");
		int verticalId = pageSettings.getVertical().getId();
		TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
		TransactionDetail transactionDetails = transactionDetailsDao.getTransactionDetailByXpath(healthPriceService.getTransactionId(), "health/situation/state");
		return specialOffersDao.getSpecialOffers(providerId, styleCodeId, applicationDate, transactionDetails.getTextValue(), verticalId);
	}



	public String deleteSpecialOffers(HttpServletRequest request,AuthenticatedData authenticatedData)   {
		try {
			Date serverDate = ApplicationService.getApplicationDate(request);
			final String userName = authenticatedData.getUid();
			final String ipAddress = request.getRemoteAddr();
			return specialOffersDao.deleteSpecialOffers(request.getParameter("offerId"),serverDate,userName,ipAddress);
		} catch (DaoException d) {
			throw new RuntimeException(d);
		}
	}
	
}
