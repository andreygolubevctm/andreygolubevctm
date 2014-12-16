package com.ctm.router;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.ctm.dao.TransactionDetailsDao;
import com.ctm.dao.homeloan.HomeloanUnconfirmedLeadsDao;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.SettingsService;
import com.ctm.services.homeloan.HomeLoanOpportunityService;
import com.ctm.services.homeloan.HomeLoanService;

/**
 * Use the pattern of:
 *  cron/{period}/{vertical}/usefulName.json
 * If a script is run every 3 hours, its hourly.
 * If a script is run every 3 days, its daily.
 * This will help guide INF in setup, and gives us visibility over Cron schedules.
 */
@WebServlet(urlPatterns = {
		"/cron/hourly/homeloan/flexOutboundLead.json"
		//,
		//"/cron/hourly/vertical/doSomethingHourly.json",
		//"/cron/daily/vertical/doSomethingDaily.json",
		//"/cron/monthly/vertical/doSomethingMonthly.json",
})
public class CronRouter extends HttpServlet {

	private static Logger logger = Logger.getLogger(CronRouter.class.getName());

	private static final long serialVersionUID = 18L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();

		// Automatically set content type based on request extension ////////////////////////////////////////

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Route the requests ///////////////////////////////////////////////////////////////////////////////
		if (uri.endsWith("/cron/hourly/homeloan/flexOutboundLead.json")) {
			try {
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.HOMELOAN.getCode());
				HomeLoanService homeLoanService = new HomeLoanService(new TransactionDetailsDao() ,  new HomeloanUnconfirmedLeadsDao() , new HomeLoanOpportunityService());
				homeLoanService.scheduledLeadGenerator(request);
			} catch(Exception e) {
				logger.error("Homeloan_flexOutboundLead cron failed", e);
			}

		}


	}
}
