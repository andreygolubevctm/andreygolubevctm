package com.ctm.router;

import com.ctm.security.token.JwtTokenCreator;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.EnvironmentService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.utils.ResponseUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

import static com.ctm.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
		"/session_poke.json"
})
public class SessionPokeRouter extends HttpServlet {
	private static final long serialVersionUID = 27L;
	private static final Logger LOGGER = LoggerFactory.getLogger(SessionPokeRouter.class);

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		SettingsService settingsService = new SettingsService(request);
		TokenCreatorConfig tokenCreatorConfig = new TokenCreatorConfig();
		JwtTokenCreator transactionVerifier = new JwtTokenCreator(settingsService, tokenCreatorConfig);
		SessionDataService sessionDataService = new SessionDataService(transactionVerifier);
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		// Stop our requests from caching ////////////////////////////////////////////////////////////////////
		response.setHeader("Cache-Control","no-cache, max-age=0");
		response.setHeader("Pragma","no-cache");
		response.setHeader("Expires","-1");

		response.setContentType("application/json");

		// Route the requests ///////////////////////////////////////////////////////////////////////////////

		if (uri.endsWith("/session_poke.json")) {
			JSONObject json = new JSONObject();
			final String check = request.getParameter("check");
			boolean justCheck = check != null;
			try {
				if (!justCheck) {
					sessionDataService.touchSession(request);
					ResponseUtils.setToken(json, sessionDataService.updateToken(request));
				}
				long timeout = sessionDataService.getClientSessionTimeout(request);

				if(timeout == -1) {
					String bigIPCookieValue = sessionDataService.getCookieByName(request, EnvironmentService.getBIGIPCookieId());
					json.put("bigIP", bigIPCookieValue);
				}

				json.put("timeout", timeout);
			} catch (JSONException e) {
				LOGGER.error("Failed to produce JSON object for Session Poke {}", kv("check", check), e);
			}

			writer.print(json.toString());
		}
	}

}
