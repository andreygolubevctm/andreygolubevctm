package com.ctm.router;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.LogAudit;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.ResetPasswordService;
import com.ctm.services.SettingsService;

@WebServlet(urlPatterns = {
		"/generic/reset_password"
})
public class GenericRouter extends HttpServlet {
	
	private static Logger logger = Logger.getLogger(GenericRouter.class.getName());

	private static final long serialVersionUID = 6314229727186633148L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();

		response.setContentType("application/json");

		PageSettings pageSettings = null;
		try {
			Brand brand = ApplicationService.getBrandFromRequest(request);
			pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.GENERIC.getCode());
			JSONObject jsonResponse = null;
			if (uri.endsWith("/reset_password")) {
				jsonResponse = routeToResetPassword(request, brand.getCode(), pageSettings);
			}
			if(jsonResponse != null){	
				response.getWriter().print(jsonResponse.toString());
			}
		} catch (DaoException | ConfigSettingException e) {
			logger.error(e);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR );
		}
	}

	private JSONObject routeToResetPassword(HttpServletRequest request,String brandCode, PageSettings pageSettings) {
		int brandId = pageSettings.getBrandId();
		String resetId = request.getParameter("reset_id");
		String resetPassword = request.getParameter("reset_password");
		ResetPasswordService resetPasswordService = new ResetPasswordService(brandCode, brandId);
		String serverName = request.getServerName();
		String requestUri = request.getScheme() + "://" + serverName + ":" + request.getServerPort() + request.getRequestURI();
		LogAudit logAudit = new LogAudit();
		logAudit.setRequestUri(requestUri);
		logAudit.setUserAgent(request.getHeader("User-Agent"));
		logAudit.setSessionId(request.getSession().getId());
		logAudit.setIp(request.getRemoteAddr());
		return resetPasswordService.reset(resetId, resetPassword, logAudit);
	}
}
