package com.ctm.web.health.router;

import com.ctm.web.core.coupon.dao.CouponDao;
import com.ctm.web.core.coupon.model.Coupon;
import com.ctm.web.core.coupon.model.CouponChannel;
import com.ctm.web.core.exceptions.DaoException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Path("/health")
public class HealthCouponRouter {
	private static final Logger LOGGER = LoggerFactory.getLogger(HealthCouponRouter.class);

	@GET
	@Path("/coupon/current/ctm.json")
	@Produces("application/json")
	public List<Coupon> getCurrentCoupon(@Context HttpServletRequest request, @Context HttpServletResponse response) {
		CouponDao couponDao = new CouponDao();
		try {
			// Only return one coupon
			return couponDao.getAvailableCoupons(1, 4, CouponChannel.ONLINE, LocalDateTime.now()).stream().limit(1).collect(Collectors.toList());
		} catch (DaoException e) {
			LOGGER.error("Failed to getCurrentCoupon", e);
		}
		return Collections.emptyList();
	}
}
