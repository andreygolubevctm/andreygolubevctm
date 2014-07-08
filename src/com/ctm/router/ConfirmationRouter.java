package com.ctm.router;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.services.confirmation.ConfirmationService;


@WebServlet(urlPatterns = {
		"/viewConfirmation"
})
public class ConfirmationRouter extends HttpServlet {
	private static final long serialVersionUID = 66L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();

		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/viewConfirmation")) {
			String confirmationKey = null;
			if (request.getParameter("key") != null) {
				confirmationKey = request.getParameter("key");
			}

			ConfirmationService confirmationService = new ConfirmationService();
			String confirmationUrl = confirmationService.getViewConfirmationUrl(confirmationKey);

			// Validate the URL
			if (confirmationUrl.length() == 0) {
				throw new ServletException("Could not route confirmation key to a valid URL.");
			}

			// Redirect to the appropriate brand/vertical
			response.sendRedirect(confirmationUrl);
		}
	}

}
