package com.ctm.web.core.router;

import com.ctm.web.core.services.CronService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * Use the pattern of:
 *  cron/{period}/{vertical}/usefulName.json
 * If a script is run every 3 hours, its hourly.
 * If a script is run every 3 days, its daily.
 * This will help guide INF in setup, and gives us visibility over Cron schedules.
 */
@WebServlet(urlPatterns = {
		"/cron/monthly.json",
		"/cron/fortnightly.json",
		"/cron/weekly.json",
		"/cron/daily.json",
		"/cron/hourly.json",
		"/cron/30minutes.json",
		"/cron/25minutes.json",
		"/cron/20minutes.json",
		"/cron/15minutes.json",
		"/cron/10minutes.json",
		"/cron/5minutes.json",
		"/cron/1minute.json"
})
public class CronRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(CronRouter.class);

	private static final long serialVersionUID = 18L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();

		// Automatically set content type based on request extension ////////////////////////////////////////
		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		// Route the requests ///////////////////////////////////////////////////////////////////////////////
			String frequency = null;
			if (uri.endsWith("/cron/monthly.json")) {
				frequency = "monthly";
			} else if (uri.endsWith("/cron/fortnightly.json")) {
				frequency = "fortnightly";
			} else if (uri.endsWith("/cron/weekly.json")) {
				frequency = "weekly";
			} else if (uri.endsWith("/cron/daily.json")) {
				frequency = "daily";
			} else if (uri.endsWith("/cron/hourly.json")) {
				frequency = "hourly";
			} else if(uri.endsWith("/cron/30minutes.json")) {
				frequency = "30minutes";
			} else if(uri.endsWith("/cron/25minutes.json")) {
				frequency = "25minutes";
			} else if(uri.endsWith("/cron/20minutes.json")) {
				frequency = "20minutes";
			} else if(uri.endsWith("/cron/15minutes.json")) {
				frequency = "15minutes";
			} else if(uri.endsWith("/cron/10minutes.json")) {
				frequency = "10minutes";
			} else if(uri.endsWith("/cron/5minutes.json")) {
				frequency = "5minutes";
			} else if(uri.endsWith("/cron/1minute.json")) {
				frequency = "1minute";
			}

			if(frequency != null) {
				try {
					CronService.execute(request, frequency);
				} catch(Exception e) {
					LOGGER.error("Cron job failed {}, {}", kv("frequency", frequency), kv("uri", request.getRequestURI()), e);
				}
			}
	}
}
