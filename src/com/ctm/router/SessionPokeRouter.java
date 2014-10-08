package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.services.SessionDataService;

@WebServlet(urlPatterns = {
		"/session_poke.json"
})
public class SessionPokeRouter extends HttpServlet {
	private static final long serialVersionUID = 27L;
	private static Logger logger = Logger.getLogger(SessionPokeRouter.class.getName());

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Stop our requests from caching ////////////////////////////////////////////////////////////////////
		response.setHeader("Cache-Control","no-cache, max-age=0");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","-1");
		
		response.setContentType("application/json");
		
		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/session_poke.json")) {	
			if (request.getParameter("check") == null)
				SessionDataService.touchSession(request);

			JSONObject json = new JSONObject();
			
			try{
				long timeout = SessionDataService.getClientSessionTimeout(request);
				json.put("timeout",  timeout);
			} catch (JSONException e) {
				logger.error("Failed to produce JSON object for Session Poke", e);
			}

			writer.print(json.toString());
		}
	}

}
