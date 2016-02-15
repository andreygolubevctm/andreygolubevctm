package com.ctm.web.core.leadfeed.utils;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.leadfeed.exceptions.LeadFeedException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LeadFeed {

	private static final Logger LOGGER = LoggerFactory.getLogger(LeadFeed.class);
	private final ContentService contentService;

	protected LeadFeedTouchService leadFeedTouchService;

	protected Content ignoreBecauseOfField = null;
	protected String ignorePhoneRule = null;

	public LeadFeed(ContentService contentService, LeadFeedTouchService leadFeedTouchService) {
		this.contentService = contentService;
        this.leadFeedTouchService = leadFeedTouchService;
	}

	/**
	 * isTestOnlyLead() will check whether the email or phone number in the lead data has been
	 * flagged as test data.
	 *
	 * @param leadData
	 * @return
	 * @throws LeadFeedException
	 */
	public Boolean isTestOnlyLead(LeadFeedData leadData) throws LeadFeedException {
		return isTestOnlyLead(leadData.getPhoneNumber(), leadData.getBrandId(), leadData.getVerticalId(), leadData.getEventDate());
	}

	/**
	 * isTestOnlyLead() will check whether the email or phone number in the lead data has been
	 * flagged as test data.
	 *
	 * @param brandId
	 * @param verticalId
	 * @param eventDate
	 * @return
	 * @throws LeadFeedException
	 */
	public  Boolean isTestOnlyLead(String phoneNumber,
										 int brandId,
										 int verticalId,
										 Date eventDate) throws LeadFeedException {
		try {
			if(ignoreBecauseOfField instanceof Content == false) {
				ignoreBecauseOfField = contentService.getContent("ignoreMatchingFormField",brandId, verticalId, eventDate, true);
				ignorePhoneRule = ignoreBecauseOfField.getSupplementaryValueByKey("phone");
			}
			if(ignorePhoneRule != null && !ignorePhoneRule.isEmpty() && ignorePhoneRule.contains(phoneNumber)) {
				LOGGER.debug("[Lead feed] Lead identified as test-only because of phone number {}", kv("phoneNumber",phoneNumber));
				return true;
			} else {
				return false;
			}
		} catch(DaoException e) {
			throw new LeadFeedException(e.getMessage(), e);
		}
	}

	public Boolean  isTestOnlyLead(String phoneNumber, Brand brand, Vertical.VerticalType verticalType, Date eventDate) throws LeadFeedException {
		return isTestOnlyLead(phoneNumber, brand.getId(), brand.getVerticalByCode(verticalType.getCode()).getId(), eventDate);
	};
}
