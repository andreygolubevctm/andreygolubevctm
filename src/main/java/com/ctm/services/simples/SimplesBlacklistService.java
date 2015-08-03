package com.ctm.services.simples;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.dao.BlacklistDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.model.simples.BlacklistChannel;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.services.StampingService;

public class SimplesBlacklistService {
	private static final Logger logger = Logger.getLogger(SimplesBlacklistService.class.getName());



	/**
	 * Add a value(phone number) to the blacklist against certain channel (phone, sms) and brand.
	 *
	 * @param pageContext
	 * @param channel
	 * @param value
	 * @param operator
	 * @param comment
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @return Success true, otherwise false
	 */
	public boolean addToBlacklist(HttpServletRequest request, String channel, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		BlacklistDao blacklistDao = new BlacklistDao();
		int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();

		try {
			int outcome = blacklistDao.add(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "on", operator, comment);
			}else{
				return false;
			}
		} catch (DaoException e) {
			logger.error("Could not add to blacklist" , e);
			return false;
		}
		return true;
	}


	/**
	 * Delete a value(phone number) from the blacklist against certain channel (phone, sms) and brand.
	 *
	 * @param pageContext
	 * @param channel
	 * @param value
	 * @param operator
	 * @param comment
	 * @throws DaoException
	 * @throws ConfigSettingException
	 * @return Success true, otherwise false
	 */
	public boolean deleteFromBlacklist(HttpServletRequest request, String channel, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		BlacklistDao blacklistDao = new BlacklistDao();
		int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();

		try {
			int outcome = blacklistDao.delete(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "off", operator, comment);
			}else{
				return false;
			}
		}
		catch (DaoException e) {
			logger.error("Could not delete from blacklist" , e);
			return false;
		}
		return true;
	}

	/**
	 * Internal method to write stamp when successful insert or delete has been done to blacklist table
	 *
	 * @param pageContext
	 * @param channel
	 * @param target
	 * @param operator
	 * @param comment
	 * @throws DaoException
	 * @throws ConfigSettingException
	 */
	private void writeBlacklistStamp(HttpServletRequest request, String channel, String target, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
		int styleCodeId = pageSettings.getBrandId();
		String brand = pageSettings.getBrandCode();
		String ipAddress = request.getRemoteAddr();
		String action = BlacklistChannel.findByCode(channel).getAction();
		StampingService stampingService = new StampingService();
		stampingService.writeStamp(styleCodeId, action, brand, Vertical.VerticalType.SIMPLES.getCode().toLowerCase(), target, value, operator, comment, ipAddress);
	}

}
