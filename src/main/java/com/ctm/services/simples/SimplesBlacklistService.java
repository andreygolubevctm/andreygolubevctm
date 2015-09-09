package com.ctm.services.simples;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.BlacklistDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.model.simples.BlacklistChannel;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.services.StampingService;

import static com.ctm.logging.LoggingArguments.kv;

public class SimplesBlacklistService {
	private static final Logger logger = LoggerFactory.getLogger(SimplesBlacklistService.class.getName());



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
	public String addToBlacklist(HttpServletRequest request, String channel, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		BlacklistDao blacklistDao = new BlacklistDao();
		int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();
		String result = null;
		try {
			int outcome = blacklistDao.add(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "on", operator, comment);
				result="success";
			}else{
				result="Entry "+ value +" ["+channel+"] already exists.";
			}
		} catch (DaoException e) {
			logger.error("Could not add to blacklist {},{},{},{}", kv("channel", channel), kv("value", value), kv("operator", operator),
				kv("comment", comment));
			result=e.getMessage();
		}
		return result;
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
	public String deleteFromBlacklist(HttpServletRequest request, String channel, String value, String operator, String comment) throws DaoException, ConfigSettingException{
		BlacklistDao blacklistDao = new BlacklistDao();
		int styleCodeId = ApplicationService.getBrandFromRequest(request).getId();
		String result = null;
		try {
			int outcome = blacklistDao.delete(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "off", operator, comment);
				result="success";
			}else{
				result="Entry "+ value +" ["+channel+"] does not exist.";
			}
		}
		catch (DaoException e) {
			logger.error("Could not delete from blacklist {},{},{},{}" , kv("channel",channel), kv("value", value),
				kv("operator",operator), kv("comment", comment), e);
			result=e.getMessage();
		}
		return result;
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
