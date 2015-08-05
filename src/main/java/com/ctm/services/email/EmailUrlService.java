package com.ctm.services.email;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

import org.apache.log4j.Logger;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.EmailMaster;
import com.ctm.model.email.IncomingEmail;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.utils.FormDateUtils;

public class EmailUrlService {

	private static Logger logger = Logger.getLogger(EmailUrlService.class.getName());

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
			logger.error(e);
		}
		return "email=" + email;
	}


	public static String decodeEmailAddress(String email) {
		if(email != null && !email.isEmpty()) {
			try {
				// + in the url gets converted to a space an email address will never have a space see http://en.wikipedia.org/wiki/Email_address#RFC_specification
				email = URLDecoder.decode(email, "UTF-8").replace(" ", "+");
			} catch (UnsupportedEncodingException e) {
				logger.error(e);
			}
		}
		return email;
	}
}
