package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.ctm.model.email.EmailMode;
import com.ctm.services.email.EmailService;


@WebServlet(urlPatterns = {
	"/bestprice/send/email.json",
	"/productBrochures/send/email.json"
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

		EmailService emailService = new EmailService();
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
