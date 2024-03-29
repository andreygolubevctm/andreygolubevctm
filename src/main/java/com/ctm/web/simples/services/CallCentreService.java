package com.ctm.web.simples.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.session.SessionData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.model.InboundPhoneNumber;
import com.ctm.web.simples.phone.verint.CtiPhoneService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import static com.ctm.commonlogging.common.LoggingArguments.kv;

import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;

public class CallCentreService {
    private static final Logger LOGGER = LoggerFactory.getLogger(CallCentreService.class);
	/**
	 * If operator is on a call, collect the details such as VDN.
	 *
	 * @param request
	 * @return
	 */
	public static InboundPhoneNumber getInboundPhoneDetails(HttpServletRequest request) throws DaoException, ConfigSettingException {
		SessionDataService sessionDataService = new SessionDataService();
		SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
		AuthenticatedData authData = sessionData.getAuthenticatedSessionData();
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);

		InboundPhoneNumber inboundPhoneDetails = CtiPhoneService.getCurrentInboundCallDetailsForAgent(pageSettings, authData);

		return inboundPhoneDetails;
	}

	/**
	 * Start a new quote, either redirect to the brand selection page or automatically detect the brand from the current phone call.
	 *
	 * @param request
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
	 * @param request
	 * @param brandId
	 * @param verticalCode
	 * @return redirectUrl
	 */
	public static String createHandoverUrl(HttpServletRequest request, int brandId, String verticalCode, String transactionId, String vdn) throws Exception{
		SessionDataService sessionDataService = new SessionDataService();
		SessionData sessionData = sessionDataService.getSessionDataFromSession(request);

		Brand currentBrand = ApplicationService.getBrandFromRequest(request);
		Brand brand = ApplicationService.getBrandById(brandId);
		if(brandId == 9) {
			brand.setCode("wfdd");
		} else if(brandId == 10) {
			brand.setCode("bddd");
		}
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

		if(brandId == 9) {
			brand.setCode("wfdd");
			redirectUrl.append("&brandCode=wfdd");
		} else if(brandId == 10) {
			brand.setCode("bddd");
			redirectUrl.append("&brandCode=bddd");
		} else if(EnvironmentService.needsManuallyAddedBrandCodeParamWhiteLabel(brand.getCode(), verticalCode)) {
			redirectUrl.append("&brandCode=").append(brand.getCode());
		}

		if(vdn != null && !vdn.equals("")){
			redirectUrl.append("&vdn=").append(vdn);
		}

        LOGGER.debug("CallCentreService createHandoverUrl {}, {}",kv("redirectUrl",redirectUrl.toString()),kv("brandCode",brand.getCode()),kv("transactionId",transactionId));

		return redirectUrl.toString();
	}

	/**
	 * Westfund usernames are prefixed with wfd. This message is used to determine which styleCode should be used
	 * when performing transaction searches. The default is CTM otherwise is based on whether you are an admin or
	 * a WFDD consultant.
	 * @param request
	 * @return
	 */
	public static String getConsultantStyleCodeId(HttpServletRequest request) {
		String styleCodeId = String.valueOf(Integer.MAX_VALUE); // Default to impossible value
		try {
			SessionDataService sessionDataService = new SessionDataService();
			SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
			AuthenticatedData authData = sessionData.getAuthenticatedSessionData();
			String uid = authData.getUid();
			if (uid != null) {
				if (getConsultantIsAdmin(request)) {
					styleCodeId = "1,9,10";
				} else if (uid.toLowerCase().startsWith("wfd")) {
					styleCodeId = "9";
				} else if (uid.toLowerCase().startsWith("bud")) {
					styleCodeId = "10";
				} else {
					styleCodeId = "1";
				}
				LOGGER.info("Authenticated user uid of " + uid + " has styleCodeId of " + styleCodeId);
			}
		} catch(Exception e) {
			LOGGER.error("No authenticated session exists. Default search styleCodeId of " + styleCodeId + " to be used.");
		}
		return styleCodeId;
	}

	public static boolean getConsultantIsAdmin(HttpServletRequest request) {
		return request.isUserInRole("BD-HCC-MGR") || request.isUserInRole("BC-IT-ECOM-RPT") ||
				request.isUserInRole("CTM-IT-USR") || request.isUserInRole("jira-ctm-projmgr");
	}
}
