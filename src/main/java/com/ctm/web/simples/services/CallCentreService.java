package com.ctm.web.simples.services;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.*;
import com.ctm.web.simples.model.InboundPhoneNumber;

public class CallCentreService {

	/**
	 * If operator is on a call, collect the details such as VDN.
	 *
	 * @param pageContext
	 * @return
	 */
	public static InboundPhoneNumber getInboundPhoneDetails(HttpServletRequest request) throws DaoException, ConfigSettingException {
		SessionDataService sessionDataService = new SessionDataService();
		SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
		AuthenticatedData authData = sessionData.getAuthenticatedSessionData();
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);

		InboundPhoneNumber inboundPhoneDetails = PhoneService.getCurrentInboundCallDetailsForAgent(pageSettings, authData);

		return inboundPhoneDetails;
	}

	/**
	 * Start a new quote, either redirect to the brand selection page or automatically detect the brand from the current phone call.
	 *
	 * @param pageContext
	 * @param VERTICAL_CODE
	 * @return styleCodeId
	 */
	public static int getBrandIdForNewQuote(HttpServletRequest request) throws DaoException, ConfigSettingException {

		// Check if agent is currently on an inbound call and get the brand code from the inbound number details.
		InboundPhoneNumber inboundPhoneDetails = getInboundPhoneDetails(request);
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
	 * @return redirectUrl
	 */
	public static String createHandoverUrl(HttpServletRequest request, int brandId, String verticalCode, String transactionId, String vdn) throws Exception{
		SessionDataService sessionDataService = new SessionDataService();
		SessionData sessionData = sessionDataService.getSessionDataFromSession(request);

		Brand currentBrand = ApplicationService.getBrandFromRequest(request);
		Brand brand = ApplicationService.getBrandById(brandId);

		PageSettings settings = SettingsService.getPageSettings(brandId, verticalCode);
		String brandRootUrl = settings.getBaseUrl();

		StringBuilder redirectUrl = new StringBuilder();
		redirectUrl.append(brandRootUrl).append("simples_handover.jsp?verticalCode=").append(verticalCode);

		if(currentBrand.getId() != brand.getId()){

			// Need to change domains, therefore there might not be an authenticated session available.

			AuthenticatedData authData = sessionData.getAuthenticatedSessionData();
			String uid = authData.getUid();

			String token = URLEncoder.encode(SimplesAuthenticationService.generateTokenForSimplesUser(uid), "UTF-8");

			redirectUrl.append("&token=").append(token);
		}

		if(transactionId != null){
			redirectUrl.append("&transactionId=").append(transactionId);
		}

		if(EnvironmentService.needsManuallyAddedBrandCodeParam()){
			redirectUrl.append("&brandCode=").append(brand.getCode());
		}

		if(vdn != null && !vdn.equals("")){
			redirectUrl.append("&vdn=").append(vdn);
		}

		return redirectUrl.toString();
	}

}