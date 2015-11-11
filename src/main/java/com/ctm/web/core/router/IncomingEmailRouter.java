package com.ctm.web.core.router;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.email.services.IncomingEmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

import static com.ctm.web.core.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
	"/email/incoming/gateway.json"
})
public class IncomingEmailRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(IncomingEmailRouter.class);

	private static final long serialVersionUID = 1L;

	private static final String TOUCH_TYPE = "EmlGateway";

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		// Get common parameters ////////////////////////////////////////////////////////////////////////////
		IncomingEmail emailData = null;

		String token = request.getParameter("token");
		if(token != null) {
			PageSettings settings = null;
			try {
				settings = SettingsService.getPageSettings(0, "GENERIC");
				EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(settings);
				emailData = emailTokenService.getIncomingEmailDetails(request.getParameter("token"));
			} catch (ConfigSettingException e) {
				LOGGER.error("Error getting base url {}", kv("settings", settings));
			}
		} else {
			emailData = new IncomingEmail();
			if (request.getParameter("type") != null) {
				EmailMode emailMode = EmailMode.findByCode(request.getParameter("type"));
				emailData.setEmailType(emailMode);
			}
			if (request.getParameter("pid") != null) {
				emailData.setProductId(request.getParameter("pid"));
			}
			if (request.getParameter("id") != null) {
				emailData.setTransactionId(Long.valueOf(request.getParameter("id")).longValue());
			}
			if (request.getParameter("hash") != null) {
				emailData.setEmailHash(request.getParameter("hash"));
			}
			if (request.getParameter("email") != null) {
				emailData.setEmailAddress(EmailUrlService.decodeEmailAddress(request.getParameter("email")));
			}
		}

		if (request.getParameter("cid") != null && emailData != null) {
			emailData.setCampaignId(request.getParameter("cid"));
		}

		if(emailData != null) {
			LOGGER.debug("Created incoming email data model {}", kv("incomingEmail", emailData));

			IncomingEmailService incomingEmailService = new IncomingEmailService();
			String emailUrl = incomingEmailService.getRedirectionUrl(emailData);

			AccessTouchService touchService = new AccessTouchService();
			touchService.setRequest(request);
			touchService.recordTouchWithProductCode(emailData.getTransactionId(), TOUCH_TYPE, "");

			// Validate the URL
			if (emailUrl.length() == 0) {
				throw new ServletException("Could not route email to a valid URL.");
			}

			LOGGER.debug("Email Gateway Redirect {}", kv("emailUrl", emailUrl));

			// Redirect to the appropriate brand/vertical
			response.sendRedirect(emailUrl);
		} else {
			PageSettings settings = null;
			try {
				EmailTokenService emailTokenService = EmailTokenServiceFactory.getEmailTokenServiceInstance(SettingsService.getPageSettings(0, "GENERIC"));
				Map<String, String> params = emailTokenService.decryptToken(token);

				String styleCodeId = params.get("styleCodeId");
				if( styleCodeId!= null && !styleCodeId.isEmpty()) {
					settings = SettingsService.getPageSettings(Integer.parseInt(styleCodeId), "GENERIC");
				} else {
					settings = SettingsService.getPageSettings(0, "GENERIC");
				}

				String brandRootUrl = settings.getBaseUrl();

				boolean hasLogin = emailTokenService.hasLogin(request.getParameter("token"));
				if(hasLogin) {
					LOGGER.info("Token has expired and user can login. Redirecting to retrieve_quotes.jsp {}", kv("parameters", params));
					response.sendRedirect(brandRootUrl + "retrieve_quotes.jsp");
				} else {
					LOGGER.info("Token has expired and user cannot login. Redirecting to start_quote.jsp {}", kv("parameters", params));
					response.sendRedirect(brandRootUrl  + "start_quote.jsp");
				}
			} catch (ConfigSettingException e) {
				LOGGER.error("Error getting base url {}", kv("settings", settings));
			}
		}
	}
}
