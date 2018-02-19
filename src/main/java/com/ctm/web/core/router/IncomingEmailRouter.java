package com.ctm.web.core.router;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.email.services.IncomingEmailService;
import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.email.integration.emailservice.EmailServiceClient;
import com.ctm.web.email.integration.emailservice.TokenResponse;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Supplier;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.interfaces.common.types.VerticalType.HOME;
import static com.ctm.web.core.email.services.token.EmailTokenServiceFactory.getEmailTokenServiceInstance;
import static com.ctm.web.email.integration.emailservice.EmailTokenAction.LOAD;
import static java.lang.Boolean.FALSE;
import static java.lang.Boolean.TRUE;
import static java.util.Collections.emptyMap;
import static java.util.Optional.empty;
import static org.apache.commons.lang3.StringUtils.isNotBlank;
import static org.springframework.util.CollectionUtils.isEmpty;
import static org.springframework.web.context.support.WebApplicationContextUtils.getWebApplicationContext;

@WebServlet(urlPatterns = {
	"/email/incoming/gateway.json"
})
public class IncomingEmailRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(IncomingEmailRouter.class);

	private static final long serialVersionUID = 1L;

	private static final String TOUCH_TYPE = "EmlGateway";

	private EmailServiceClient emailServiceClient;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        final Boolean canBeRedirectToEvtJourney = this.redirectToEverestJourney(request, response);
        if (canBeRedirectToEvtJourney) return;

		// Get common parameters ////////////////////////////////////////////////////////////////////////////
		IncomingEmail emailData = null;

		String token = request.getParameter("token");
		if(token != null) {
			PageSettings settings = null;
			try {
				settings = SettingsService.getPageSettings(0, "GENERIC");
				EmailTokenService emailTokenService = getEmailTokenServiceInstance(settings);
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

		if (request.getParameter("gaclientid") != null && emailData != null) {
			emailData.setGAClientId(request.getParameter("gaclientid"));
		}

		if (request.getParameter("cid") != null && emailData != null) {
			emailData.setCampaignId(request.getParameter("cid"));
		}

		if (request.getParameter("et_rid") != null && emailData != null) {
			emailData.setETRid(request.getParameter("et_rid"));
		}

		if (request.getParameter("utm_source") != null && emailData != null) {
			emailData.setUTMSource(request.getParameter("utm_source"));
		}

		if (request.getParameter("utm_medium") != null && emailData != null) {
			emailData.setUTMMedium(request.getParameter("utm_medium"));
		}

		if (request.getParameter("utm_campaign") != null && emailData != null) {
			emailData.setUTMCampaign(request.getParameter("utm_campaign"));
		}

		if(emailData != null) {
			LOGGER.debug("Created incoming email data model {}", kv("incomingEmail", emailData));

			IncomingEmailService incomingEmailService = new IncomingEmailService();
			String emailUrl = incomingEmailService.getRedirectionUrl(emailData);

			AccessTouchService touchService = new AccessTouchService();
			touchService.setRequest(request);
			touchService.recordTouchWithProductCodeDeprecated(emailData.getTransactionId(), TOUCH_TYPE, "");

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
				EmailTokenService emailTokenService = getEmailTokenServiceInstance(SettingsService.getPageSettings(0, "GENERIC"));
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

	private Boolean redirectToEverestJourney(final HttpServletRequest request,
											 final HttpServletResponse response) throws IOException, ServletException {

		// check and retrieve token from request
		final String token = request.getParameter("token");
		if (StringUtils.isBlank(token)) {
			LOGGER.error("Not found token from request");
			return FALSE;
		}

		// decrypt email token to a map of params
		final Supplier<Map<String, String>> supEmailTokenParams = () -> {
			try {
				EmailTokenService emailTokenService = getEmailTokenServiceInstance(SettingsService.getPageSettings(0, "GENERIC"));
				Map<String, String> params = emailTokenService.decryptToken(token);
				return params;
			} catch (ConfigSettingException ex) {
				LOGGER.error("Failed to decrypt email token [{}]", token);
				return emptyMap();
			}
		};

		// early exit if unable to decrypt token
		final Map<String, String> params = supEmailTokenParams.get();
		if (isEmpty(params)) return FALSE;

		// util function: get param value by name
		final Function<String, Optional<String>> getParam = (paramName) -> Optional.ofNullable(params.get(paramName))
				.filter(StringUtils::isNotBlank);

		// get vertical type first for early exit
		final VerticalType verticalType = getParam.apply("vertical")
				.map(String::toUpperCase)
				.map(VerticalType::valueOf)
				.orElse(null);
		if (verticalType != HOME) return FALSE;

		// preparing values to generate EVT email token
		final Optional<Integer> optStyleCodeId = getParam.apply("styleCodeId").map(NumberUtils::toInt);
		final Optional<Long> optTransactionId = getParam.apply("transactionId").map(NumberUtils::toLong);
		final Optional<Integer> optEmailId = getParam.apply("emailId").map(NumberUtils::toInt);

		// supply injected emailServiceClient
		final Supplier<EmailServiceClient> supEmailServiceClient = () -> {
			final WebApplicationContext applicationContext = getWebApplicationContext(request.getServletContext());
			final EmailServiceClient emailServiceClient = applicationContext.getBean(EmailServiceClient.class);
			return emailServiceClient;
		};

		// supply a new EmailMasterDao with default styleCodeId = 1
		final Supplier<EmailMasterDao> supEmailMasterDao = () -> new EmailMasterDao(optStyleCodeId.orElse(1));

		// retrieve emailMaster
		final Optional<EmailMaster> optEmailMaster = optEmailId.flatMap(emailId -> {
			try {
				return Optional.ofNullable(supEmailMasterDao.get().getEmailMasterById(emailId))
						.filter(emailMaster -> isNotBlank(emailMaster.getEmailAddress()));
			} catch (DaoException ex) {
				LOGGER.error(ex.getMessage(), ex);
				return empty();
			}
		});

		// integrate with email-service to generate EVT load-dispatcher url
		if (optStyleCodeId.isPresent() && optTransactionId.isPresent() && optEmailMaster.isPresent()) {
			if (emailServiceClient == null) emailServiceClient = supEmailServiceClient.get();
			final Optional<String> optEvtRedirectUrl = emailServiceClient
					.createEmailToken(optStyleCodeId.get(), verticalType, optTransactionId.get(), LOAD, optEmailMaster.get())
					.map(TokenResponse::getUrl);
			if (optEvtRedirectUrl.isPresent()) {
				LOGGER.info("Redirecting HNC Transaction to EVT journey {}", kv("parameters", params));
				response.sendRedirect(optEvtRedirectUrl.get());
				return TRUE;
			}
		}

		return FALSE;
	}
}
