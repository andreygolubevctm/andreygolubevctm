package com.ctm.web.core.coupon.services;

import com.ctm.web.core.coupon.dao.CouponDao;
import com.ctm.web.core.coupon.model.Coupon;
import com.ctm.web.core.coupon.model.CouponChannel;
import com.ctm.web.core.coupon.model.CouponOpenHoursCondition;
import com.ctm.web.core.coupon.model.request.CouponRequest;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.coupon.model.CouponOpenHoursCondition.CLOSED;
import static com.ctm.web.core.coupon.model.CouponOpenHoursCondition.OPEN;

@Component
public class CouponService {
	private static final Logger LOGGER = LoggerFactory.getLogger(CouponService.class);
	private CouponDao couponDao;
	private OpeningHoursService openingHoursService;

	// Constructor required for JSP usage
	public CouponService(){
		this.couponDao = new CouponDao();
		this.openingHoursService = new OpeningHoursService();
	}

	@Autowired
	public CouponService(CouponDao couponDao, OpeningHoursService openingHoursService) {
		this.couponDao = couponDao;
		this.openingHoursService = openingHoursService;
	}

	public Coupon getCouponById(CouponRequest couponRequest) throws DaoException {
		return couponDao.getCouponById(couponRequest);
	}

	public Coupon getCouponByVdn(CouponRequest couponRequest) throws DaoException {
		final CouponOpenHoursCondition openHoursCondition = getOpenHoursCondition(couponRequest.verticalId, DateUtils.toLocalDateTime(couponRequest.effectiveDate));
		return couponDao.getCouponByVdn(couponRequest, Optional.of(openHoursCondition));
	}

	public Coupon validateCouponCode(CouponRequest couponRequest, Data data) throws DaoException {
		final CouponOpenHoursCondition openHoursCondition = getOpenHoursCondition(couponRequest.verticalId, DateUtils.toLocalDateTime(couponRequest.effectiveDate));
		return validateHardRules(couponDao.getCouponByCode(couponRequest, Optional.of(openHoursCondition)), data);
	}

	private Coupon validateHardRules(Coupon coupon, Data data) throws DaoException {
		CouponRulesService couponRulesService = new CouponRulesService();
		couponDao.setRulesForCoupon(coupon);
		couponRulesService.filterHardRules(coupon, data);
		return coupon;
	}

	public Coupon filterCouponForUser(CouponRequest couponRequest, Data data) throws DaoException {
		CouponRulesService couponRulesService = new CouponRulesService();

		if (couponRequest.couponId > 0) {
			Coupon coupon = getCouponById(couponRequest);
			if(coupon.isExclusive()) {
				couponDao.setRulesForCoupon(coupon);
				if (couponRulesService.filterAllRules(coupon, data)) {
					return coupon;
				}
			}
		} else {
			List<Coupon> coupons = getActiveCoupons(couponRequest.styleCodeId, couponRequest.verticalId,
					couponRequest.couponChannel, DateUtils.toLocalDateTime(couponRequest.effectiveDate));

			if (!coupons.isEmpty()) {
				for (Coupon coupon : coupons) {
					if(!coupon.isExclusive()) {
						couponDao.setRulesForCoupon(coupon);
						if (couponRulesService.filterAllRules(coupon, data)) {
							return coupon;
						}
					}
				}
			}
		}

		return new Coupon();
	}

	/**
	 * Used in jsp, to check if we need to show coupon field during page load
	 */
	public boolean canShowCouponField(HttpServletRequest request, String couponChannelCode) {
		try {
			PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);

			int styleCodeId = pageSettings.getBrandId();
			int verticalId = pageSettings.getVertical().getId();
			Date effectiveDate = ApplicationService.getApplicationDate(request);

			List<Coupon> coupons = getActiveCoupons(styleCodeId, verticalId,
					CouponChannel.findByCode(couponChannelCode), DateUtils.toLocalDateTime(effectiveDate));
			return !coupons.isEmpty();
		} catch (DaoException | ConfigSettingException e) {
			LOGGER.error("Failed to check if coupon field can be displayed {}", kv("couponChannelCode", couponChannelCode), e);
		}
		return false;

	}

	/**
	 * Used in jsp, to get coupon confirmation html for confirmation page
	 */
	public String getCouponForConfirmation(String transactionId) {
		String confirmationHTML = "";
		try {
			Coupon coupon = couponDao.getCouponForConfirmation(transactionId);
			if (coupon.getCouponId() > 0 && coupon.getContentConfirmation() != null) {
				confirmationHTML = coupon.getContentConfirmation();
			}
		} catch (DaoException e) {
			LOGGER.error("Failed to get coupon confirmation html for " + transactionId, e);
		}
		return confirmationHTML;
	}

	/**
	 * Get active coupons now, taking into account if the call centre is currently open or closed.
	 * Result is cached for a short period.
	 */
	@Cacheable(cacheNames = {"couponGetActiveCouponsCache"})
	public List<Coupon> getActiveCoupons(int styleCodeId, int verticalId, CouponChannel couponChannel) throws DaoException {
		final LocalDateTime now = LocalDateTime.now();
		final CouponOpenHoursCondition openHoursCondition = getOpenHoursCondition(verticalId, now);
		return couponDao.getAvailableCoupons(styleCodeId, verticalId, couponChannel, now, Optional.of(openHoursCondition));
	}

	/**
	 * Get active coupons at a specific datetime, taking into account if the call centre is currently open or closed.
	 */
	public List<Coupon> getActiveCoupons(int styleCodeId, int verticalId, CouponChannel couponChannel, LocalDateTime effectiveDate) throws DaoException {
		final CouponOpenHoursCondition openHoursCondition = getOpenHoursCondition(verticalId, effectiveDate);
		return couponDao.getAvailableCoupons(styleCodeId, verticalId, couponChannel, effectiveDate, Optional.of(openHoursCondition));
	}

	private CouponOpenHoursCondition getOpenHoursCondition(int verticalId, LocalDateTime now) throws DaoException {
		return openingHoursService.isCallCentreOpen(verticalId, now) ? OPEN : CLOSED;
	}
}
