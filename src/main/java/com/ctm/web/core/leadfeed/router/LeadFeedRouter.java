package com.ctm.web.core.leadfeed.router;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.leadService.model.LeadType;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.model.LeadFeedData.CallType;
import com.ctm.web.core.leadfeed.services.LeadFeedService;
import com.ctm.web.core.leadfeed.services.LeadFeedService.LeadResponseStatus;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public abstract class LeadFeedRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(LeadFeedRouter.class);

	private static final long serialVersionUID = 1L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		response.setContentType("application/json");
        Map<String, String[]> params = request.getParameterMap();
		try {
			LeadResponseStatus output = LeadResponseStatus.FAILURE;
			LeadFeedService service = getLeadFeedService();
			// Get settings
			SettingsService.setVerticalAndGetSettingsForPage(request, getVerticalCode());
			// Convert request data into generic lead object
			LeadFeedData leadDataPack = getLeadFromRequest(request, getVerticalCode());

			if (uri.endsWith("/getacall.json")) {

				// Call Lead Feed Service
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
			LOGGER.error("[Lead feed] Router failed {}", kv("requestUri", request.getRequestURI()), e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
				lead.setLeadType(LeadType.CALL_DIRECT);
			}
			if(CallType.GET_CALLBACK.equals(calltype)){
				lead.setCallType(CallType.GET_CALLBACK);
				lead.setLeadType(LeadType.CALL_ME_BACK);
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

		lead.setClientIpAddress(IPAddressHandler.getInstance().getIPAddress(request));

		return lead;
	}

	protected abstract String getVerticalCode();

	protected abstract LeadFeedService getLeadFeedService();

}
