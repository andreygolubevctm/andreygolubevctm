package com.ctm.web.simples.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.Unsubscribe;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.services.StampingService;
import com.ctm.web.core.services.UnsubscribeService;
import com.ctm.web.simples.dao.BlacklistDao;
import com.ctm.web.simples.model.BlacklistChannel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class SimplesBlacklistService {
	private static final Logger LOGGER = LoggerFactory.getLogger(SimplesBlacklistService.class);

	private final IPAddressHandler ipAddressHandler;

    @Autowired
	public SimplesBlacklistService(IPAddressHandler ipAddressHandler) {
		this.ipAddressHandler = ipAddressHandler;
	}


	/**
	 * Add a value(phone number) to the blacklist against certain channel (phone, sms) and brand.
	 *
	 * @param request
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
		String result;
		try {
			int outcome = blacklistDao.add(styleCodeId, BlacklistChannel.findByCode(channel), value);
			if (outcome > 0) {
				writeBlacklistStamp(request, channel, value, "on", operator, comment);
				result="success";
			}else{
				result="Entry "+ value +" ["+channel+"] already exists.";
			}
		} catch (DaoException e) {
			LOGGER.error("Could not add to blacklist {},{},{},{}", kv("channel", channel), kv("value", value), kv("operator", operator),
				kv("comment", comment));
			result=e.getMessage();
		}
		return result;
	}


	/**
	 * Delete a value(phone number) from the blacklist against certain channel (phone, sms) and brand.
	 *
	 * @param request
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
		String result;
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
			LOGGER.error("Could not delete from blacklist {},{},{},{}" , kv("channel",channel), kv("value", value),
				kv("operator",operator), kv("comment", comment), e);
			result=e.getMessage();
		}
		return result;
	}



    /**
	 *
	 * @param request
     * @param pageSettings
     * @param email
     * @param operator
     * @param comment
     * @throws DaoException
     * @throws ConfigSettingException
	 */
	public String unsubscribeFromSimples(HttpServletRequest request, PageSettings pageSettings, String email, String operator, String comment) throws DaoException, ConfigSettingException {

		EmailMasterDao emailDao = new EmailMasterDao(pageSettings.getBrandId(), pageSettings.getBrandCode(), null);
		EmailMaster emailDetails = emailDao.getEmailMaster(email);
		UnsubscribeService unsubscribeService = new UnsubscribeService(emailDao);
		Unsubscribe unsubscribe = new Unsubscribe();

		unsubscribe.setEmailDetails(emailDetails);
		unsubscribe.setVertical(null);

        String result;
        try {
            int outcome = unsubscribeService.unsubscribe(pageSettings, unsubscribe);
			if (outcome > 0) {
				writeBlacklistStamp(request, "email", email, "N", operator, comment);
				result = "success";
			} else {
				result = "Warning: " + email + " doesn't exist.";
			}
        }
        catch (DaoException e) {
            LOGGER.error("Could not unsubscribe email from simples {},{},{}" , kv("email", email), kv("operator",operator), kv("comment", comment), e);
            result = e.getMessage();
        }

        return result;
	}

	/**
	 * Internal method to write stamp when successful insert or delete has been done to blacklist table
	 *
	 * @param request
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
		String ipAddress = ipAddressHandler.getIPAddress(request);
		String action = BlacklistChannel.findByCode(channel).getAction();
		StampingService stampingService = new StampingService();
		stampingService.writeStamp(styleCodeId, action, brand, Vertical.VerticalType.SIMPLES.getCode().toLowerCase(), target, value, operator, comment, ipAddress);
	}

}
