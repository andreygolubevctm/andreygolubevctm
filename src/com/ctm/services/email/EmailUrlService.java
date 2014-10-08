package com.ctm.services.email;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.EmailDetails;
import com.ctm.model.settings.Vertical.VerticalType;

public class EmailUrlService {

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
	public String getUnsubscribeUrl(EmailDetails emailDetails) {
		return baseUrl + "unsubscribe.jsp?unsubscribe_email=" + emailDetails.getHashedEmail() + "&vertical=" + vertical.getCode();
	}

	/**
	 * Returns the load from link
	 *
	 * @param emailDetails
	 * @param productId
	 * @param productTitle
	 */
	public String getApplyUrl(EmailDetails emailDetails, long transactionId,  String type)
			throws ConfigSettingException {
		return baseUrl + "load_from_email.jsp?action=load&type=" + type + "&id=" + transactionId + "&hash=" +
			emailDetails.getHashedEmail() + "&vertical=" + vertical.getCode().toLowerCase();
	}
	
	/**
	 * Returns the load from link
	 *
	 * @param emailDetails
	 * @param productId
	 * @param productTitle
	 */
	public String getApplyUrl(EmailDetails emailDetails, long transactionId,  String type, String productId, String productTitle)
			throws ConfigSettingException {
		return getApplyUrl(emailDetails, transactionId,  type) +"&productId=" + productId +"&productTitle=" + productTitle;
	}

}
