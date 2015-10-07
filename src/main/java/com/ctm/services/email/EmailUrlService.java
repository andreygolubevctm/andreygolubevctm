package com.ctm.services.email;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.EmailMaster;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.TokenService;
import com.ctm.utils.FormDateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Map;

import static com.ctm.logging.LoggingArguments.kv;

public class EmailUrlService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailUrlService.class);

	private VerticalType vertical;
	private String baseUrl;

	public static final String TRANSACTION_ID = "transactionId";
	public static final String EMAIL_ID = "emailId";
	public static final String EMAIL_TOKEN_TYPE = "emailTokenType";
	public static final String EMAIL_TOKEN_ACTION = "action";
	public static final String PRODUCT_ID = "productId";
	public static final String CAMPAIGN_ID = "campaignId";
	public static final String VERTICAL = "vertical";
	public static final String PRODUCT_NAME = "productName";
	public static final String TRAVEL_POLICY_TYPE = "travelPolicyType";
	public static final String HASHED_EMAIL = "hashedEmail";
	public static final String STYLE_CODE_ID = "styleCodeId";
	public static final String EMAIL_ADDRESS = "emailAddress";

	public EmailUrlService(VerticalType vertical, String baseUrl) {
		this.vertical = vertical;
		this.baseUrl = baseUrl;
	}

	/**
	 * Returns the unsubscribe link
	 *
	 * @param params
	 */
	public String getUnsubscribeUrl(Map<String, String> params) {
		TokenService tokenService = new TokenService();
		String token = tokenService.generateToken(params);
		return baseUrl + "unsubscribe.jsp?token=" + token;
	}

	/**
	 * Returns the load from link
	 *
	 * @param params
	 */
	public String getApplyUrl(EmailMaster emailDetails, Map<String, String> params) throws ConfigSettingException {
		params.put(EmailUrlService.EMAIL_ADDRESS, createEmailParam(emailDetails));

		TokenService tokenService = new TokenService();
		String token = tokenService.generateToken(params);

		return baseUrl + "load_from_email.jsp?token=" + token;
	}

	private String createVericalParam()  {
		return "vertical=" + vertical.getCode().toLowerCase();
	}

	/**
	 * updateWithLoadQuoteUrl provides a common method to update the redirection URL to load the quote
	 *
	 * @param redirectionUrl
	 * @param emailData
	 */
	public void updateWithLoadQuoteUrl(StringBuilder redirectionUrl, IncomingEmail emailData) {
		redirectionUrl.append(baseUrl);
		redirectionUrl.append("load_from_email.jsp?action=load&id=" + emailData.getTransactionId());
		redirectionUrl.append("&hash=" + emailData.getHashedEmail() + "&" + createVericalParam());
		if(emailData.getEmailType() != null) {
			redirectionUrl.append("&type=" + emailData.getEmailType());
		}
		if(emailData.getCampaignId() != null) {
			redirectionUrl.append("&cid=" + emailData.getCampaignId());
		}
		redirectionUrl.append("&" + createEmailParam(emailData.getEmailMaster()));
	}

	/**
	 * updateAsExpired provides a common method to update the redirection URL with expired param
	 *
	 * @param redirectionUrl
	 */
	public void updateAsExpired(StringBuilder redirectionUrl) {
		redirectionUrl.append("&expired=" + FormDateUtils.getTodaysDate("dd/MM/yyyy"));
	}


	private String createEmailParam(EmailMaster emailDetails)  {
		String email = emailDetails.getEmailAddress();
		try {
			email= URLEncoder.encode(email , "UTF-8");
		} catch (UnsupportedEncodingException e) {
			LOGGER.error("Unable to encode email address to UTF-8 {}", kv("emailAddress", email), e);
		}
		return email;
	}


	public static String decodeEmailAddress(String email) {
		if(email != null && !email.isEmpty()) {
			try {
				// + in the url gets converted to a space an email address will never have a space see http://en.wikipedia.org/wiki/Email_address#RFC_specification
				email = URLDecoder.decode(email, "UTF-8").replace(" ", "+");
			} catch (UnsupportedEncodingException e) {
				LOGGER.error("Unable to decode email address to UTF-8 {}", kv("emailAddress", email), e);
			}
		}
		return email;
	}
}
