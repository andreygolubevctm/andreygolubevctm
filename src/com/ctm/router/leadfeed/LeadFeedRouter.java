package com.ctm.router.leadfeed;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.ctm.dao.TransactionDetailsDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.leadfeed.LeadFeedData;
import com.ctm.model.session.SessionData;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.ApplicationService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.leadfeed.car.CarLeadFeedService;
import com.disc_au.web.go.Data;
import com.disc_au.web.go.xml.HttpRequestHandler;

@WebServlet(urlPatterns = {
	"/leadfeed/car/getacall.json"
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

			String output = null;

			if (uri.endsWith("/leadfeed/car/getacall.json")) {

				// Get settings for Car
				SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.CAR.getCode());

				// Convert request data into generic lead object
				LeadFeedData leadDataPack = getLeadFromRequest(request);

				// Save updates to data bucket to the DB
				updateBucket(request, leadDataPack.getTransactionId());

				// Call Lead Feed Service
				CarLeadFeedService service = new CarLeadFeedService();
				output = service.callMeBack(leadDataPack);

			}

			if(output.equalsIgnoreCase("ok")) {
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
	private LeadFeedData getLeadFromRequest(HttpServletRequest request) throws DaoException{
		LeadFeedData lead = new LeadFeedData();

		lead.setBrandCode(ApplicationService.getBrandCodeFromRequest(request));

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

		lead.setClientIpAddress(request.getRemoteAddr());

		return lead;
	}

	protected Boolean updateBucket(HttpServletRequest request, Long transactionId) throws SessionException {

		SessionDataService sessionDataService = new SessionDataService();

		SessionData sessionData = sessionDataService.getSessionDataFromSession(request);
		if (sessionData == null) {
			throw new SessionException("session has expired");
		}
		Data data = sessionData.getSessionDataForTransactionId(transactionId);

		if(data != null) {
			HttpRequestHandler.updateXmlNode(data, request, true, false);
		}

		TransactionDetailsDao transactionDetailsDao = new TransactionDetailsDao();
		return transactionDetailsDao.insertOrUpdate(request, transactionId);
	}
}
