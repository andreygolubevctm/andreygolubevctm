package com.ctm.services;

import java.net.URLEncoder;

import javax.servlet.jsp.PageContext;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.session.SessionData;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.simples.InboundPhoneNumber;

public class CallCentreService {

	/**
	 * Start a new quote, either redirect to the brand selection page or automatically detect the brand from the current phone call.
	 *
	 * @param pageContext
	 * @param verticalCode
	 * @return
	 * @throws DaoException 
	 * @throws ConfigSettingException 
	 * @throws Exception
	 */
	public static int getBrandIdForNewQuote(PageContext pageContext) throws DaoException, ConfigSettingException {

		SessionData sessionData = SessionDataService.getSessionDataFromPageContext(pageContext);
		AuthenticatedData authData = sessionData.getAuthenticatedSessionData();
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(pageContext);

		// Check if agent is currently on an inbound call and get the brand code from the inbound number details.
		InboundPhoneNumber inboundPhoneDetails = PhoneService.getCurrentInboundCallDetailsForAgent(pageSettings, authData);
		if(inboundPhoneDetails != null){
			return inboundPhoneDetails.getStyleCodeId();
		}

		return -1;

	}

	/**
	 * Create link for simples users to swap primary domains.
	 * This will land on a page which will attempt to use the token to log the user back in.
	 *
	 * @param pageContext
	 * @param brandId
	 * @param verticalCode
	 * @return
	 * @throws Exception
	 */
	public static String createHandoverUrl(PageContext pageContext, int brandId, String verticalCode, String transactionId) throws Exception{

		SessionData sessionData = SessionDataService.getSessionDataFromPageContext(pageContext);

		Brand currentBrand = ApplicationService.getBrandFromPageContext(pageContext);
		Brand brand = ApplicationService.getBrandById(brandId);

		PageSettings settings = SettingsService.getPageSettings(brandId, verticalCode);
		String brandRootUrl = settings.getBaseUrl();

		String redirectUrl = brandRootUrl+"simples_handover.jsp?verticalCode="+verticalCode;

		if(currentBrand.getId() != brand.getId()){

			// Need to change domains, therefore there might not be an authenticated session available.

			AuthenticatedData authData = sessionData.getAuthenticatedSessionData();
			String uid = authData.getUid();

			String token = URLEncoder.encode(AuthenticationService.generateTokenForSimplesUser(uid), "UTF-8");

			redirectUrl += "&token="+token;
		}

		if(transactionId != null){
			redirectUrl += "&transactionId="+transactionId;
		}

		if(EnvironmentService.needsManuallyAddedBrandCodeParam()){
			redirectUrl += "&brandCode="+brand.getCode();
		}

		return redirectUrl;
	}

}
