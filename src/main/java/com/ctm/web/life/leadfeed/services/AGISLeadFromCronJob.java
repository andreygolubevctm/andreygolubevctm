package com.ctm.web.life.leadfeed.services;

import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao;
import com.ctm.web.core.transaction.model.Transaction;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import org.apache.taglibs.standard.tag.common.sql.ResultImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.SortedMap;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class AGISLeadFromCronJob {

	private static final Logger LOGGER = LoggerFactory.getLogger(AGISLeadFromCronJob.class);
	
	public String newLeadFeed(String transactionId, ResultImpl transactionDetails, ResultImpl rankingDetails, PageSettings pageSettings) {

		LeadFeedService.LeadResponseStatus output = LeadFeedService.LeadResponseStatus.FAILURE;

		try {
			LeadFeedData lead = new LeadFeedData();
			lead.setTransactionId(Long.valueOf(transactionId));

			// Get a transaction model so that we can derive the brand/vertical details
			TransactionDao tranDao = new TransactionDao();
			Transaction transaction = new Transaction();
			transaction.setTransactionId(lead.getTransactionId());
			transaction = tranDao.getCoreInformation(transaction);

			lead.setEventDate(ApplicationService.getServerDate());
			lead.setBrandCode(transaction.getStyleCodeName().toLowerCase());
			lead.setVerticalCode(transaction.getVerticalCode().toUpperCase());
			lead.setBrandId(transaction.getStyleCodeId());
			Brand brand = ApplicationService.getBrandByCode(lead.getBrandCode());
			lead.setVerticalId(brand.getVerticalByCode(lead.getVerticalCode()).getId());

			String firstName = "";
			String lastName = "";

			for (SortedMap<?, ?> detail : transactionDetails.getRows()) {
				String xpath = (String) detail.get("xpath");
				String value = (String) detail.get("textValue");

				switch (xpath) {
					case "life/clientIpAddress":
						lead.setClientIpAddress(value);
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

			for (SortedMap<?, ?> detail : rankingDetails.getRows()) {
				String property = (String) detail.get("Property");
				String value = (String) detail.get("Value");

				switch (property) {
					case "leadNumber":
						lead.setPartnerReference(value);
						break;
					case "company":
						lead.setProductId(value);
						break;
					case "partnerBrand":
						lead.setPartnerBrand(value);
					default:
						break;
				}
			}

			lead.setClientName((firstName + " " + lastName).trim());

			// Call Lead Feed Service
			LifeLeadFeedService service = new LifeLeadFeedService(new BestPriceLeadsDao());
			output = service.bestPrice(lead);
		} catch (Exception e) {
			LOGGER.error("[lead feed] Cron failed sending AGIS lead feed {}", kv("transactionId", transactionId),
				kv("pageSettings", pageSettings), e);
		}

		if(output == LeadFeedService.LeadResponseStatus.SUCCESS) {
			return "OK";
		} else {
			return "ERROR";
		}
	}
	
}
