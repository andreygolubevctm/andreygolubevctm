package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import com.ctm.services.email.EmailService;
import com.ctm.services.email.EmailServiceHandler.EmailMode;


@WebServlet(urlPatterns = {
	"/bestprice/send/email.json"
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
		if (uri.contains("bestprice")) {
			emailAddress = request.getParameter("email");
			mode = EmailMode.BEST_PRICE;

		}
		responseJson = emailService.send(request, mode, emailAddress);
		if(responseJson != null){
			writer.print(responseJson.toString());
		}
	}
}
