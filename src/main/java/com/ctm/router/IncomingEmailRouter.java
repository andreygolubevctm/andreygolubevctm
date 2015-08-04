package com.ctm.router;

import com.ctm.model.email.EmailMode;
import com.ctm.model.email.IncomingEmail;
import com.ctm.services.AccessTouchService;
import com.ctm.services.email.EmailUrlService;
import com.ctm.services.email.IncomingEmailService;
import org.apache.log4j.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {
	"/email/incoming/gateway.json"
})
public class IncomingEmailRouter extends HttpServlet {

	private static Logger logger = Logger.getLogger(IncomingEmailRouter.class.getName());

	private static final long serialVersionUID = 1L;

	private static final String TOUCH_TYPE = "EmlGateway";

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		// Get common parameters ////////////////////////////////////////////////////////////////////////////
		IncomingEmail emailData = new IncomingEmail();

		if (request.getParameter("type") != null) {
			EmailMode emailMode = EmailMode.findByCode(request.getParameter("type"));
			emailData.setEmailType(emailMode);
		}
		if (request.getParameter("pid") != null) {
			emailData.setProductId(request.getParameter("pid"));
		}
		if (request.getParameter("id") != null) {
			emailData.setTransactionId(Long.valueOf(request.getParameter("id")).longValue());
		}
		if (request.getParameter("hash") != null) {
			emailData.setEmailHash(request.getParameter("hash"));
		}
		if (request.getParameter("email") != null) {
			emailData.setEmailAddress(EmailUrlService.decodeEmailAddress(request.getParameter("email")));
		}
		if (request.getParameter("cid") != null) {
			emailData.setCampaignId(request.getParameter("cid"));
		}

		logger.debug("EmailIncomingRouter: " + emailData.getEmailType() + ", " + emailData.getProductId() + ", " + emailData.getTransactionId() + ", " + emailData.getHashedEmail());

		IncomingEmailService incomingEmailService = new IncomingEmailService();
		String emailUrl = incomingEmailService.getRedirectionUrl(emailData);

		AccessTouchService touchService = new AccessTouchService();
		touchService.setRequest(request);
		touchService.recordTouchWithProductCode(emailData.getTransactionId(), TOUCH_TYPE, "");

		// Validate the URL
		if (emailUrl.length() == 0) {
			throw new ServletException("Could not route email to a valid URL.");
		}

		logger.debug("Email Gateway Redirect URL: " + emailUrl);

		// Redirect to the appropriate brand/vertical
		response.sendRedirect(emailUrl);
	}
}
