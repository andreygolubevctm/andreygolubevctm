package com.ctm.router.leadfeed;

import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.ContentService;
import com.ctm.services.leadfeed.car.CarLeadFeedService;
import com.ctm.services.leadfeed.homecontents.HomeContentsLeadFeedService;
import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebServlet(urlPatterns = {
	"/cron/leadfeed/car/triggerBestPriceLeads.json",
	"/cron/leadfeed/home/triggerBestPriceLeads.json"
})
public class BestPriceLeadsRouter extends HttpServlet {

	private static Logger logger = Logger.getLogger(BestPriceLeadsRouter.class.getName());

	private static final long serialVersionUID = 1L;


	/** ENUM needed to enable brand specific checks as to whether to proceed
	 *  with using this method to action leads (otherwise overridden and use DISC)
	 **/
	private static enum BestPriceLeadDISCOverride {
		CTM(1, "ctm", "N"),
		CC(3, "cc", "N"),
		CHOO(8, "choo", "N");

		private Integer brandCodeId;
		private String brandCode;
		private String override;

		BestPriceLeadDISCOverride(Integer brandCodeId, String brandCode, String override) {
			setBrandCodeId(brandCodeId);
			setBrandCode(brandCode);
			setOverride(override);
		}

		public Integer getBrandCodeId() {
			return brandCodeId;
		}

		public void setBrandCodeId(Integer brandCodeId) {
			this.brandCodeId = brandCodeId;
		}

		public String getBrandCode() {
			return brandCode;
		}

		public void setBrandCode(String brandCode) {
			this.brandCode = brandCode;
		}

		public String getOverride() {
			return override;
		}

		public void setOverride(String override) {
			this.override = override;
		}
	}

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		logger.info("[Lead feed] Trigger cron job");

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		response.setContentType("application/json");

		try {

			Date serverDate = ApplicationService.getApplicationDate(request);
			for (BestPriceLeadDISCOverride bestPriceOverride : BestPriceLeadDISCOverride.values()) {
				String tempOverride = ContentService.getInstance().getContent("bestPriceCallDisc", bestPriceOverride.getBrandCodeId(), 0, serverDate, false).getContentValue();
				if(tempOverride != null) {
					bestPriceOverride.setOverride(tempOverride);
				}

				// Only attempt bestprice lead call if no DISC override in content control
				// Overrides are on brand level - not vertical level - so use GENERIC
				if(bestPriceOverride.getOverride().equalsIgnoreCase("n")) {

					String output = null;

					if (uri.endsWith("/triggerBestPriceLeads.json")) {
						Integer frequency = 10;
						if (request.getParameter("freq") != null) {
							frequency = Integer.valueOf(request.getParameter("freq")).intValue();
						}

						if(uri.contains("/car/")) {
							CarLeadFeedService carLeadService = new CarLeadFeedService();
							output = carLeadService.processBestPriceLeads(bestPriceOverride.getBrandCodeId(), Vertical.VerticalType.CAR.getCode(), frequency, serverDate);
						} else if(uri.contains("/home/")) {
							HomeContentsLeadFeedService homeLeadService = new HomeContentsLeadFeedService();
							output = homeLeadService.processBestPriceLeads(bestPriceOverride.getBrandCodeId(), Vertical.VerticalType.HOME.getCode(), frequency, serverDate);
						}
					}

					if(output != null) {
						writer.print(output);
					}
				}
			}

		} catch (Exception e) {
			logger.error("[Lead feed] Exception sending lead feed message",e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR );
		}
	}
}
