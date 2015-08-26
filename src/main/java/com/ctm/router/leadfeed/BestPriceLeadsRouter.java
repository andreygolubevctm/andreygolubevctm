package com.ctm.router.leadfeed;

import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.services.ApplicationService;
import com.ctm.services.leadfeed.car.CarLeadFeedService;
import com.ctm.services.leadfeed.homecontents.HomeContentsLeadFeedService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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

	private static final Logger logger = LoggerFactory.getLogger(BestPriceLeadsRouter.class.getName());

	private static final long serialVersionUID = 1L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		logger.info("[Lead feed] Trigger cron job");

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		response.setContentType("application/json");

		try {

			Date serverDate = ApplicationService.getApplicationDate(request);


				String output = "";

				if (uri.endsWith("/triggerBestPriceLeads.json")) {

					Integer frequency = 10;
					if (request.getParameter("freq") != null) {
						frequency = Integer.valueOf(request.getParameter("freq")).intValue();
					}

					if(uri.contains("/car/")) {

						// Look for each brand which is enabled for CAR
						for(Brand brand :  ApplicationService.getBrands()){
							Vertical vertical = brand.getVerticalByCode(Vertical.VerticalType.CAR.getCode());
							if(vertical != null){
								CarLeadFeedService carLeadService = new CarLeadFeedService();
								output += carLeadService.processBestPriceLeads(brand.getId(), Vertical.VerticalType.CAR.getCode(), frequency, serverDate);

							}
						}

					} else if(uri.contains("/home/")) {

						// Look for each brand which is enabled for H&C
						for(Brand brand :  ApplicationService.getBrands()){
							Vertical vertical = brand.getVerticalByCode(Vertical.VerticalType.HOME.getCode());
							if(vertical != null){
								HomeContentsLeadFeedService homeLeadService = new HomeContentsLeadFeedService();
								output += homeLeadService.processBestPriceLeads(brand.getId(), Vertical.VerticalType.HOME.getCode(), frequency, serverDate);

							}
						}

					}
				}

				if(output.equals("") == false) {
					writer.print(output);
				}

		} catch (Exception e) {
			logger.error("[Lead feed] Exception sending lead feed message",e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR );
		}
	}
}
