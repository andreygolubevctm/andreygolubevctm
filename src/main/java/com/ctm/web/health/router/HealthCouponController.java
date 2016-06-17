package com.ctm.web.health.router;

import com.ctm.web.core.coupon.model.Coupon;
import com.ctm.web.core.coupon.model.CouponChannel;
import com.ctm.web.core.coupon.model.Views;
import com.ctm.web.core.coupon.services.CouponService;
import com.ctm.web.core.exceptions.DaoException;
import com.fasterxml.jackson.annotation.JsonView;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Api(basePath = "/rest/health/coupon", value = "Health coupon")
@RestController
@RequestMapping("/rest/health/coupon")
public class HealthCouponController {
	private static final Logger LOGGER = LoggerFactory.getLogger(HealthCouponController.class);

	private CouponService couponService;

	@Autowired
	public HealthCouponController(CouponService couponService) {
		this.couponService = couponService;
	}

	@JsonView(Views.ForWordpressSite.class)
	@ApiOperation(value = "current/ctm.json", notes = "Get current coupon", produces = "application/json")
	@RequestMapping(value = "/current/ctm.json", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Coupon> getCurrentCoupon(HttpServletRequest request, HttpServletResponse response) {
		addAllowOriginHeader(request, response);
		try {
			// Only return maximum of one coupon
			// Returns a list to describe "0 or 1" items
			return couponService.getActiveCoupons(1, 4, CouponChannel.ONLINE).stream().limit(1).collect(Collectors.toList());
		} catch (DaoException e) {
			LOGGER.error("Failed to getCurrentCoupon", e);
		}
		return Collections.emptyList();
	}

	private void addAllowOriginHeader(HttpServletRequest request, HttpServletResponse response) {
		final Optional<String> origin = Optional.ofNullable(request.getHeader("Origin"))
				.map(String::toLowerCase)
				.filter(s -> s.contains("comparethemarket.com.au"));
		if (origin.isPresent()) {
			LOGGER.debug("Adding Allow-Origin header for: {}", kv("remote address access", origin));
			response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
		}
	}
}
