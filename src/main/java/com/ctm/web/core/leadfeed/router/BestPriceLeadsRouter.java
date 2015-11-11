package com.ctm.web.core.leadfeed.router;

import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import static com.ctm.web.core.logging.LoggingArguments.kv;

public abstract class BestPriceLeadsRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(BestPriceLeadsRouter.class);

	private static final long serialVersionUID = 1L;



	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		LOGGER.debug("[Lead feed] Triggered cron job {}", kv("uri", request.getRequestURI()));

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		response.setContentType("application/json");

		try {
			Date serverDate = ApplicationService.getApplicationDate(request);
			String output = "";

			if (uri.endsWith("/triggerBestPriceLeads.json")) {
				LeadFeedService leadService = getLeadFeedService();

					Integer frequency = 10;
					if (request.getParameter("freq") != null) {
						frequency = Integer.valueOf(request.getParameter("freq")).intValue();
					}

					// Look for each brand which is enabled for H&C
					for(Brand brand :  ApplicationService.getBrands()){
						Vertical vertical = brand.getVerticalByCode(getVerticalCode());
						if(vertical != null){
							output += leadService.processBestPriceLeads(brand.getId(), getVerticalCode(), frequency, serverDate);
						}
					}
				}

				if(!output.isEmpty()) {
					writer.print(output);
				}

		} catch (Exception e) {
			LOGGER.error("[Lead feed] Best price lead feed failed {}", request.getRequestURI(), e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR );
		}
	}

	protected abstract String getVerticalCode();

	protected abstract LeadFeedService getLeadFeedService();
}
