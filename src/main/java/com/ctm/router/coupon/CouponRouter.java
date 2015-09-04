package com.ctm.router.coupon;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.exceptions.DaoException;
import com.ctm.model.Error;
import com.ctm.model.coupon.CouponChannel;
import com.ctm.model.request.coupon.CouponRequest;
import com.ctm.model.session.AuthenticatedData;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.SessionDataService;
import com.ctm.services.SettingsService;
import com.ctm.services.coupon.CouponService;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;

import static com.ctm.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
		"/coupon/id/get.json",
		"/coupon/filter.json",
		"/coupon/code/validate.json",
		"/coupon/vdn/get.json"
})

public class CouponRouter extends HttpServlet {
	private static final Logger logger = LoggerFactory.getLogger(CouponRouter.class.getName());
	private static final long serialVersionUID = 24L;
	private final SessionDataService sessionDataService = new SessionDataService();
	private final CouponService couponService = new CouponService();

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		AuthenticatedData authenticatedData;
		if (request.getSession() != null) {
			authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
		} else {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}

		CouponRequest couponRequest = new CouponRequest();

		try {
			long transactionId = RequestUtils.getTransactionIdFromRequest(request);
			Data data = RequestUtils.getValidDataBucket(request, transactionId);

			PageSettings pageSettings = SettingsService.getPageSettingsByCode(ApplicationService.getBrandCodeFromTransactionSessionData(data), ApplicationService.getVerticalCodeFromTransactionSessionData(data));

			couponRequest.transactionId = transactionId;
			couponRequest.styleCodeId = pageSettings.getBrandId();
			couponRequest.verticalId = pageSettings.getVertical().getId();
			couponRequest.effectiveDate = ApplicationService.getApplicationDate(request);
			couponRequest.couponChannel = authenticatedData.isLoggedIn() ? CouponChannel.CALL_CENTRE : CouponChannel.ONLINE;

			if (uri.endsWith("/coupon/id/get.json")) {
				getCouponById(couponRequest, writer, request, response);
			}
			else if (uri.endsWith("/coupon/filter.json")) {
				filterCouponForUser(couponRequest, data, writer, response);
			}
			else if (uri.endsWith("/coupon/code/validate.json")) {
				validateCouponCode(couponRequest, data, writer, request, response);
			}
			else if (uri.endsWith("/coupon/vdn/get.json")) {
				getCouponByVdn(couponRequest, writer, request, response);
			}

		} catch (Exception e) {
			logger.error("Coupon request failed {}", kv("uri", request.getRequestURI()), e);
			writeErrors(e, writer, response);
		}
	}

	private void getCouponById(CouponRequest couponRequest, final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response) {
		couponRequest.couponId = Integer.parseInt(request.getParameter("couponId"));
		try {
			writer.print(couponService.getCouponById(couponRequest).toJson());
		} catch (DaoException e) {
			logger.error("Coupon fetch failed {}", kv("couponId", couponRequest.couponId), e);
			writeErrors(e, writer, response);
		}
	}

	private void filterCouponForUser(CouponRequest couponRequest, Data data, final PrintWriter writer, final HttpServletResponse response) {
		try {
			writer.print(couponService.filterCouponForUser(couponRequest, data).toJson());
		} catch (DaoException e) {
			logger.error("Coupon filter for user failed {}", kv("transactionId", couponRequest.transactionId), e);
			writeErrors(e, writer, response);
		}
	}

	private void validateCouponCode(CouponRequest couponRequest,  Data data, final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response) {
		couponRequest.couponCode = request.getParameter("couponCode");
		try {
			writer.print(couponService.validateCouponCode(couponRequest, data).toJson());
		} catch (DaoException e) {
			logger.error("Coupon validation failed {}", kv("couponCode", couponRequest.couponCode), e);
			writeErrors(e, writer, response);
		}
	}

	private void getCouponByVdn(CouponRequest couponRequest, final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response) {
		couponRequest.vdn = request.getParameter("vdn");
		try {
			writer.print(couponService.getCouponByVdn(couponRequest).toJson());
		} catch (DaoException e) {
			logger.error("Coupon fetch failed {}", kv("vdn", couponRequest.vdn), e);
			writeErrors(e, writer, response);
		}
	}

	private void writeErrors(final Exception e, final PrintWriter writer, final HttpServletResponse response) {
		final Error error = new Error();
		error.addError(new Error(e.getMessage()));
		JSONObject json = error.toJsonObject(true);
		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		writer.print(json.toString());
	}
}
