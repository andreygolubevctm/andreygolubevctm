package com.ctm.services.email;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.model.EmailMaster;
import com.ctm.web.core.model.email.IncomingEmail;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.utils.FormDateUtils;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public class EmailUrlService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EmailUrlService.class);

	private VerticalType vertical;
	private String baseUrl;

	public EmailUrlService(VerticalType vertical, String baseUrl) {
		this.vertical = vertical;
		this.baseUrl = baseUrl;
	}

	/**
	 * Returns the unsubscribe link
	 *
	 * @param emailDetails
	 */
	public String getUnsubscribeUrl(EmailMaster emailDetails) {
		return baseUrl + "unsubscribe.jsp?unsubscribe_email=" + emailDetails.getHashedEmail() + "&" + createVericalParam() + "&" + createEmailParam(emailDetails);
	}

	/**
	 * Returns the load from link
	 *
	 * @param emailDetails
	 * @param productId
	 * @param productTitle
	 */
	public String getApplyUrl(EmailMaster emailDetails, long transactionId,  String type)
			throws ConfigSettingException {
		return baseUrl + "load_from_email.jsp?action=load&type=" + type + "&id=" + transactionId + "&hash=" +
			emailDetails.getHashedEmail() + "&" + createVericalParam() + "&" + createEmailParam(emailDetails);
	}

	/**
	 * Returns the load from link
	 *
	 * @param emailDetails
	 * @param productId
	 * @param productTitle
	 * @throws UnsupportedEncodingException
	 */
	public String getApplyUrl(EmailMaster emailDetails, long transactionId,  String type, String productId, String productTitle)
			throws ConfigSettingException {
		return getApplyUrl(emailDetails, transactionId,  type) +"&productId=" + productId + "&productTitle=" + productTitle;
	}

	private String createVericalParam()  {
		return "vertical=" + vertical.getCode().toLowerCase();
	}

	/**
	 * updateWithLoadQuoteUrl provides a common method to update the redirection URL to load the quote
	 *
	 * @param redirectionUrl
	 * @param baseUrl
	 * @param vertical
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
		return "email=" + email;
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
