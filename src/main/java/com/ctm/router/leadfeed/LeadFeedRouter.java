package com.ctm.router.leadfeed;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import com.ctm.model.settings.Brand;
import com.ctm.exceptions.DaoException;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.leadfeed.LeadFeedData.CallType;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.services.leadfeed.car.CarLeadFeedService;
import com.ctm.services.leadfeed.homecontents.HomeContentsLeadFeedService;
import com.ctm.services.leadfeed.LeadFeedService.LeadResponseStatus;

@WebServlet(urlPatterns = {
	"/leadfeed/car/getacall.json",
	"/leadfeed/homecontents/getacall.json"
})
public class LeadFeedRouter extends HttpServlet {

	private static Logger logger = Logger.getLogger(LeadFeedRouter.class.getName());

	private static final long serialVersionUID = 1L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		response.setContentType("application/json");

		try {
			LeadResponseStatus output = LeadResponseStatus.FAILURE;

			if (uri.endsWith("/leadfeed/car/getacall.json")) {

				// Get settings for Car
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.CAR.getCode());

				// Convert request data into generic lead object
				LeadFeedData leadDataPack = getLeadFromRequest(request, VerticalType.CAR.getCode());

				// Call Lead Feed Service
				CarLeadFeedService service = new CarLeadFeedService();
				switch(leadDataPack.getCallType()) {
				case CALL_DIRECT:
					output = service.callDirect(leadDataPack);
					break;
				case GET_CALLBACK:
					output = service.callMeBack(leadDataPack);
					break;
				case NOSALE_CALL:
					output = service.noSaleCall(leadDataPack);
					break;
				}

			} else if (uri.endsWith("/leadfeed/homecontents/getacall.json")) {

				// Get settings for Car
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.HOME.getCode());

				// Convert request data into generic lead object
				LeadFeedData leadDataPack = getLeadFromRequest(request, VerticalType.HOME.getCode());

				// Call Lead Feed Service
				HomeContentsLeadFeedService service = new HomeContentsLeadFeedService();
				switch(leadDataPack.getCallType()) {
				case CALL_DIRECT:
					output = service.callDirect(leadDataPack);
					break;
				case GET_CALLBACK:
					output = service.callMeBack(leadDataPack);
					break;
				case NOSALE_CALL:
					output = service.noSaleCall(leadDataPack);
					break;
				}
			}

			if(output == LeadResponseStatus.SUCCESS) {
				writer.print("{\"result\":true}");
			} else {
				writer.print("{\"result\":false}");
			}

		} catch (Exception e) {
			logger.error("[Lead feed] Router caught exception", e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR );
		}
	}

	/**
	 * Populate a lead feed object from request params
	 * @param request
	 * @return
	 * @throws DaoException
	 */
	private LeadFeedData getLeadFromRequest(HttpServletRequest request, String verticalCode) throws DaoException{
		LeadFeedData lead = new LeadFeedData();

		lead.setEventDate(ApplicationService.getApplicationDate(request));

		lead.setBrandCode(ApplicationService.getBrandCodeFromRequest(request));

		Brand brand = ApplicationService.getBrandByCode(lead.getBrandCode());
		lead.setBrandId(brand.getId());
		lead.setVerticalCode(verticalCode);
		lead.setVerticalId(brand.getVerticalByCode(verticalCode).getId());

		if (request.getParameter("phonecallme") != null) {
			String calltype = request.getParameter("phonecallme");
			if(CallType.CALL_DIRECT.equals(calltype)){
				lead.setCallType(CallType.CALL_DIRECT);
			}
			if(CallType.GET_CALLBACK.equals(calltype)){
				lead.setCallType(CallType.GET_CALLBACK);
			}
			if(CallType.NOSALE_CALL.equals(calltype)){
				lead.setCallType(CallType.NOSALE_CALL);
			}
		}

		if (request.getParameter("transactionId") != null) {
			Long tranId = Long.parseLong(request.getParameter("transactionId"));
			lead.setTransactionId(tranId);
		}

		if (request.getParameter("clientName") != null) {
			lead.setClientName(request.getParameter("clientName"));
		}

		if (request.getParameter("phoneNumber") != null) {
			lead.setPhoneNumber(request.getParameter("phoneNumber"));
		}

		if (request.getParameter("clientNumber") != null) {
			lead.setPartnerReference(request.getParameter("clientNumber"));
		}

		if (request.getParameter("state") != null) {
			lead.setState(request.getParameter("state"));
		}

		if (request.getParameter("brand") != null) {
			lead.setPartnerBrand(request.getParameter("brand"));
		}

		if (request.getParameter("vdn") != null) {
			lead.setVdn(request.getParameter("vdn"));
		}

		if (request.getParameter("productId") != null) {
			lead.setProductId(request.getParameter("productId"));
		}

		lead.setClientIpAddress(request.getRemoteAddr());

		return lead;
	}
}
