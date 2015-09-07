package com.ctm.services.coupon;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.CouponDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.coupon.Coupon;
import com.ctm.model.coupon.CouponChannel;
import com.ctm.model.request.coupon.CouponRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.disc_au.web.go.Data;

import static com.ctm.logging.LoggingArguments.kv;

public class CouponService {
	private static final Logger logger = LoggerFactory.getLogger(CouponService.class.getName());
	private CouponDao couponDao;

	public CouponService(){
		this.couponDao = new CouponDao();
	}

	public CouponService(CouponDao couponDao){
		this.couponDao = couponDao;
	}

	public Coupon getCouponById(CouponRequest couponRequest) throws DaoException {
		return couponDao.getCouponById(couponRequest);
	}

	public Coupon getCouponByVdn(CouponRequest couponRequest) throws DaoException {
		return couponDao.getCouponByVdn(couponRequest);
	}

	public Coupon validateCouponCode(CouponRequest couponRequest, Data data) throws DaoException {
		return validateHardRules(couponDao.getCouponByCode(couponRequest), data);
	}

	private Coupon validateHardRules(Coupon coupon, Data data) throws DaoException {
		CouponRulesService couponRulesService = new CouponRulesService();
		couponDao.setRulesForCoupon(coupon);
		couponRulesService.filterHardRules(coupon, data);
		return coupon;
	}

	public Coupon filterCouponForUser(CouponRequest couponRequest, Data data) throws DaoException {

		CouponRulesService couponRulesService = new CouponRulesService();
		List<Coupon> coupons = couponDao.getAvailableCoupons(couponRequest);

		if(!coupons.isEmpty()){
			for(Coupon coupon : coupons){
				// Only non-exclusive coupon can be filtered and shown
				if (!coupon.isExclusive()){
					couponDao.setRulesForCoupon(coupon);
					if (couponRulesService.filterAllRules(coupon, data)) {
						return coupon;
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

			List<Coupon> coupons = couponDao.getAvailableCoupons(styleCodeId, verticalId, CouponChannel.findByCode(couponChannelCode), effectiveDate);
			return !coupons.isEmpty();
		} catch (DaoException | ConfigSettingException e) {
			logger.error("Failed to check if coupon field can be displayed {}, {}", kv("couponChannelCode", couponChannelCode), e);
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
			logger.error("Failed to get coupon confirmation html for " + transactionId, e);
		}
		return confirmationHTML;
	}
}
