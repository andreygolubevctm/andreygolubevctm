package com.ctm.web.core.router;

import com.ctm.web.core.services.tracking.JourneyGateway;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Router call the JourneyGateway service to remove any existing journey gateway cookies
 */
@WebServlet(urlPatterns = {
		"/journeyGateway/clean"
})
public class JourneyGatewayRouter extends HttpServlet {

	private static final Logger LOGGER = LoggerFactory.getLogger(JourneyGatewayRouter.class);

	private static final long serialVersionUID = 18L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		response.setContentType("text/html");
		String removedCookies = JourneyGateway.flushCookies(request);
		response.getWriter().write(removedCookies);
	}
}
