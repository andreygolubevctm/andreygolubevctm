package com.ctm.services.life;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.life.Lead;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.SessionDataService;
import com.disc_au.web.go.Data;

public class AGISLeadFromRequest {

	private Logger logger = Logger.getLogger(AGISLeadFromCronJob.class);
	
	public String newLeadFeed(HttpServletRequest request, PageSettings pageSettings, String transactionId) {
		
		Lead lead = new Lead();
		AGISLeadFeed leadFeed = new AGISLeadFeed();
		
		SessionDataService sds = new SessionDataService();
		Data data = null;
		try {
			data = sds.getDataForTransactionId(request, transactionId, false);
		} catch (DaoException | SessionException e1) {
			e1.printStackTrace();
		}
		
		String vertical = data.get("current/verticalCode").toString().toLowerCase();
		
		lead.setMessageSource(AGISLeadFeed.MessageSource.REQUEST_CALLBACK);
		lead.setPartnerReference(transactionId);		
		lead.setClientName(data.get(vertical + "/primary/firstName").toString() + " " + data.get(vertical + "/primary/lastname").toString());
		lead.setPhoneNumber(data.get(vertical + "/contactDetails/contactNumber").toString());
		lead.setSourceId(AGISLeadFeed.ProviderSourceID.valueOf(data.get("lead/company").toString().toUpperCase()));
		
		String state = data.get(vertical + "/primary/state") != null ? data.get(vertical + "/primary/state").toString() : "";
		lead.setState(state);
		
		String IPAddress = data.get(vertical + "/clientIpAddress") != null ? data.get(vertical + "/clientIpAddress").toString() : request.getRemoteAddr();
		lead.setIpAddress(IPAddress);
		
		lead.setLeadNumber(data.get("lead/leadNumber").toString());
		
		try {
			String leadResult = leadFeed.newLeadFeed(pageSettings, lead);
			
			return leadResult;
		} catch (Exception e) {
			logger.error("Life AGIS lead feed failed", e);
		}
		
		return "ERROR";
		
	}
	
}
