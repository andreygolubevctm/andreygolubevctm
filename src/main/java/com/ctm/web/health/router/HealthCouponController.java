package com.ctm.web.health.router;

import com.ctm.web.core.coupon.model.Coupon;
import com.ctm.web.core.coupon.model.CouponChannel;
import com.ctm.web.core.coupon.services.CouponService;
import com.ctm.web.core.exceptions.DaoException;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

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

	@ApiOperation(value = "current/ctm.json", notes = "Get current coupon", produces = "application/json")
	@RequestMapping(value = "/current/ctm.json",
			method = RequestMethod.GET,
			produces = MediaType.APPLICATION_JSON_VALUE)
	public List<Coupon> getCurrentCoupon() {
		try {
			// Only return maximum of one coupon
			// Returns a list to describe "0 or 1" items
			return couponService.getActiveCoupons(1, 4, CouponChannel.ONLINE).stream().limit(1).collect(Collectors.toList());
		} catch (DaoException e) {
			LOGGER.error("Failed to getCurrentCoupon", e);
		}
		return Collections.emptyList();
	}
}
