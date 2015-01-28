package com.ctm.router;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.exceptions.BrandException;
import com.ctm.model.*;
import com.ctm.model.Error;
import com.ctm.model.settings.Brand;
import com.ctm.services.ApplicationService;
import com.ctm.services.FatalErrorService;
import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.ResetPasswordService;
import com.ctm.services.SettingsService;

@WebServlet(urlPatterns = {
		"/generic/reset_password.json"
})
public class GenericRouter extends HttpServlet {
	
	private static Logger logger = Logger.getLogger(GenericRouter.class.getName());

	private static final long serialVersionUID = 6314229727186633148L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		response.setContentType("application/json");
		Brand brand = null;
		try {
			brand = ApplicationService.getBrandFromRequest(request);
			PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.GENERIC.getCode());
			JSONObject jsonResponse = null;
			if (uri.endsWith("/reset_password.json")) {
				jsonResponse = routeToResetPassword(request, brand.getCode(), pageSettings);
			}
			if(jsonResponse != null){
				response.getWriter().print(jsonResponse.toString());
			}
		} catch (DaoException | ConfigSettingException | BrandException exception) {
			handleError(request, uri, brand, exception, response);
		}
	}

	private void handleError(HttpServletRequest request, String uri, Brand brand, Exception exception, HttpServletResponse response) {
		FatalErrorService fatalErrorService = new FatalErrorService();
		logger.error("Failed to reset password ", exception);
		String sessionId = "";
		int styleCodeId = 0;
		if(request.getSession() != null){
			sessionId = request.getSession().getId();
		}
		if(brand != null){
			styleCodeId = brand.getId();
		}
		fatalErrorService.logFatalError(exception, styleCodeId, uri , sessionId, true);
		com.ctm.model.Error error = new Error();
		error.addError(new Error("Failed to reset password"));
		JSONObject json = error.toJsonObject(true);
		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		try {
			response.getWriter().print(json.toString());
		} catch (IOException e) {
			logger.error(e);
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
