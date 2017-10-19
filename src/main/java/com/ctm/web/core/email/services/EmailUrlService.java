package com.ctm.web.core.email.services;

import com.ctm.web.core.email.services.token.EmailTokenService;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.utils.FormDateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class EmailUrlService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailUrlService.class);

	private VerticalType vertical;
	private String baseUrl;
	private EmailTokenService emailTokenService;

	public static final String TRANSACTION_ID = "transactionId";
	public static final String EMAIL_ID = "emailId";
	public static final String EMAIL_TOKEN_TYPE = "emailTokenType";
	public static final String EMAIL_TOKEN_ACTION = "action";
	public static final String PRODUCT_ID = "productId";
	public static final String PRODUCT_CODE = "productCode";
	public static final String CAMPAIGN_ID = "campaignId";
	public static final String VERTICAL = "vertical";
	public static final String PRODUCT_NAME = "productName";
	public static final String TRAVEL_POLICY_TYPE = "travelPolicyType";
	public static final String HASHED_EMAIL = "hashedEmail";
	public static final String STYLE_CODE_ID = "styleCodeId";
	public static final String EMAIL_ADDRESS = "emailAddress";
    public static final String GACLIENTID = "gaclientid";
	public static final String CID = "cid";
	public static final String ET_RID = "et_rid";
	public static final String UTM_SOURCE = "utm_source";
	public static final String UTM_MEDIUM = "utm_medium";
	public static final String UTM_CAMPAIGN = "utm_campaign";

	public EmailUrlService(VerticalType vertical, String baseUrl, EmailTokenService emailTokenService) {
		this.vertical = vertical;
		this.baseUrl = baseUrl;
		this.emailTokenService = emailTokenService;
	}

	/**
	 * Returns the unsubscribe link
	 *
	 * @param params
	 */
	public String getUnsubscribeUrl(Map<String, String> params) throws ConfigSettingException {
		String token = emailTokenService.generateToken(params);
		return baseUrl + "unsubscribe.jsp?token=" + token;
	}

	/**
	 * Returns the load from link
	 *
	 * @param params
	 */
	public String getApplyUrl(EmailMaster emailDetails, Map<String, String> params, Map<String, String> otherParams) throws ConfigSettingException {
		params.put(EmailUrlService.EMAIL_ADDRESS, createEmailParam(emailDetails));

		String token = emailTokenService.generateToken(params);
		String otherParamsAsString = "";
		if (otherParams != null) {
			StringBuilder content = new StringBuilder();

			for(String key : otherParams.keySet()) {
				content.append(key);
				content.append("=");
				content.append(otherParams.get(key));
				content.append("&");
			}
			otherParamsAsString = content.toString();
		}
		return baseUrl + "load_from_email.jsp?" + otherParamsAsString + "token=" + token;
	}

	private String createVerticalParam()  {
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
		redirectionUrl.append("&hash=" + emailData.getHashedEmail() + "&" + createVerticalParam());
		if(emailData.getEmailType() != null) {
			redirectionUrl.append("&type=" + emailData.getEmailType());
		}
		if(emailData.getCampaignId() != null) {
			redirectionUrl.append("&cid=" + emailData.getCampaignId());
		}
		if(emailData.getETRid() != null) {
			redirectionUrl.append("&et_rid=" + emailData.getETRid());
		}
		if(emailData.getUTMSource() != null) {
			redirectionUrl.append("&utm_source=" + emailData.getUTMSource());
		}
		if(emailData.getUTMMedium() != null) {
			redirectionUrl.append("&utm_medium=" + emailData.getUTMMedium());
		}
		if(emailData.getUTMCampaign() != null) {
			redirectionUrl.append("&utm_campaign=" + emailData.getUTMCampaign());
		}
		redirectionUrl.append("&" + createEmailParam(emailData.getEmailMaster()));
	}

	/**
	 * updateWithTransferringData provides a common method to update the redirection URL to land on the transferring page
	 *
	 * @param redirectionUrl
	 * @param emailData
	 */
	public void updateWithTransferringData(StringBuilder redirectionUrl, IncomingEmail emailData) {
		redirectionUrl.append(baseUrl);
		redirectionUrl.append("transferring.jsp?"+createVerticalParam() + "&trackingSource=email&transactionId=" + emailData.getTransactionId());
		if(emailData.getProductId() != null) {
			redirectionUrl.append("&productId=" + emailData.getProductId());
		}
		if(emailData.getEmailType() != null) {
			redirectionUrl.append("&type=" + emailData.getEmailType());
		}
		if(emailData.getGAClientId() != null) {
			redirectionUrl.append("&gaclientid=" + emailData.getGAClientId());
		}
		if(emailData.getCampaignId() != null) {
			redirectionUrl.append("&cid=" + emailData.getCampaignId());
		}
		if(emailData.getETRid() != null) {
			redirectionUrl.append("&et_rid=" + emailData.getETRid());
		}
		if(emailData.getUTMSource() != null) {
			redirectionUrl.append("&utm_source=" + emailData.getUTMSource());
		}
		if(emailData.getUTMMedium() != null) {
			redirectionUrl.append("&utm_medium=" + emailData.getUTMMedium());
		}
		if(emailData.getUTMCampaign() != null) {
			redirectionUrl.append("&utm_campaign=" + emailData.getUTMCampaign());
		}
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
