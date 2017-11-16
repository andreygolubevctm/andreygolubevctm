package com.ctm.web.core.router;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailService;
import org.json.JSONObject;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


@WebServlet(urlPatterns = {
	"/bestprice/send/email.json",
	"/productBrochures/send/email.json",
	"/productBrochures/get/link.json"
})
public class SendEmailRouter extends HttpServlet {
	private static final long serialVersionUID = 66L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();
		JSONObject responseJson = null;
		EmailMode mode = null;
		String emailAddress = null;

		final WebApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(request.getServletContext());
		EmailService emailService = applicationContext.getBean(EmailService.class);
		if (uri.toLowerCase().contains(EmailMode.BEST_PRICE.toString())) {
			emailAddress = request.getParameter("email");
			mode = EmailMode.BEST_PRICE;

		}
		if (uri.toLowerCase().contains(EmailMode.PRODUCT_BROCHURES.toString())) {
			emailAddress = request.getParameter("email");
			mode = EmailMode.PRODUCT_BROCHURES;

		}
		responseJson = emailService.send(request, mode, emailAddress);
		if(responseJson != null){
			writer.print(responseJson.toString());
		}
	}
}
