package com.ctm.services.life;

import java.util.SortedMap;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.tag.common.sql.ResultImpl;

import com.ctm.model.life.Lead;
import com.ctm.model.settings.PageSettings;

public class AGISLeadFromCronJob {

	private Logger logger = Logger.getLogger(AGISLeadFromCronJob.class);
	
	public String newLeadFeed(String transactionId, ResultImpl transactionDetails, ResultImpl rankingDetails, PageSettings pageSettings) {
		
		Lead lead = new Lead();
		AGISLeadFeed leadFeed = new AGISLeadFeed();
		
		String firstName = "";
		String lastName = "";
		
		for (SortedMap<?, ?> detail : transactionDetails.getRows()) {
			String xpath = (String) detail.get("xpath");
			String value = (String) detail.get("textValue");
			
			switch (xpath) {
				case "life/clientIpAddress":
					lead.setIpAddress(value);
					break;
				case "life/primary/firstName":
					firstName = value;
					break;
				case "life/primary/lastname":
					lastName = value;
					break;
				case "life/primary/state":
					lead.setState(value);
					break;
				case "life/contactDetails/contactNumber":
					lead.setPhoneNumber(value);
					break;
				default:
					break;
			}
		}
		
		// If no phone number has been provided, send a fake one to meet
		// validation requirements on AGIS's side.
		if(lead.getPhoneNumber() == null) {
			lead.setPhoneNumber("0000000000");
		}
		
		for (SortedMap<?, ?> detail : rankingDetails.getRows()) {
			String property = (String) detail.get("Property");
			String value = (String) detail.get("Value");
			
			switch (property) {
				case "leadNumber":
					lead.setLeadNumber(value);
					break;
				case "company":
					AGISLeadFeed.ProviderSourceID sourceId = AGISLeadFeed.ProviderSourceID.valueOf(value.toUpperCase());
					lead.setSourceId(sourceId);
				default:
					break;
			}
		}
		
		lead.setPartnerReference(transactionId);
		lead.setMessageSource(AGISLeadFeed.MessageSource.BEST_PRICE);
		lead.setClientName(firstName + " " + lastName);
		
		try {
			String leadResult = leadFeed.newLeadFeed(pageSettings, lead);

			return leadResult;
		} catch (Exception e) {
			logger.error("Life AGIS lead feed failed", e);
		}
		
		return "ERROR";
	}
	
}
