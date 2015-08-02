package com.ctm.services;

import java.security.GeneralSecurityException;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.ctm.dao.EmailMasterDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;
import com.ctm.model.LogAudit;
import com.ctm.security.StringEncryption;

public class ResetPasswordService {
	
	private AuditService auditService;
	private String brandCode;
	private String metadata;
	private String identity;
	private AuthenticationService authenticationService;
	private EmailMasterDao emailMasterDao;

	public ResetPasswordService(String brandCode, int styleCodeId){
		this.brandCode = brandCode;
		this.auditService = new AuditService(brandCode);
		this.authenticationService = new AuthenticationService();
		emailMasterDao = new EmailMasterDao(styleCodeId);
	}
	
	public ResetPasswordService(String brandCode , AuthenticationService authenticationService, EmailMasterDao emailMasterDao, AuditService auditService){
		this.authenticationService = authenticationService;
		this.brandCode = brandCode;
		this.emailMasterDao = emailMasterDao;
		this.auditService = auditService;
	}
	
	private static Logger logger = Logger.getLogger(ResetPasswordService.class.getName());
	
	/**
	 * 	Calls the mysql database with the resetId code if found invalidate the token. If not found return an error message 
	 * 	in the JSONObject. 	If the token  matches we then overwrite the password in ctm.email_master 
	 * 	and return a JSONObject with a success message. 
	 *	@param resetId	- The temporary reset_id sent to the client in an email
	 *	@param resetPassword - The client's desired new password.
	 * 	@param logAudit information on the user such as ip address used for auditing access
	**/
	public JSONObject reset(String resetId, String resetPassword, LogAudit logAudit) {
		metadata = "";
		identity = "Unavailable";
		JSONObject response = null;
		logAudit.setAction(LogAudit.Action.RESET);
		try {
			if(!resetId.isEmpty() || !resetPassword.isEmpty()) {
				response = hasArguments(logAudit, resetId,  resetPassword);
			} else {
				response = missingArguments(logAudit);
			}
		} catch (JSONException e) {
			logger.error("Failed to reset password resetId " + resetId , e);
		}
		auditService.logAudit(logAudit, identity, metadata);
		return response;
	}
	
	private JSONObject hasArguments(LogAudit logAudit, String resetId, String resetPassword) throws JSONException {
		JSONObject response;
		logger.debug("Password Reset Called with id: " + resetId);
		int emailMasterId = authenticationService.verifyTokenForEmail(resetId);
		logger.info("Email Master ID returned with: " + emailMasterId);
		if (emailMasterId > 0) {
			try {
				EmailMaster emailMaster  = emailMasterDao.getEmailMasterById(emailMasterId);
				if(!emailMaster.getEmailAddress().isEmpty() ) {
					response = updatePassword(logAudit, resetId, resetPassword, emailMasterDao,
							emailMaster);
				} else {
					// JSON result failure - no email was found
					response = createResponse("INVALID_EMAIL", "We can't seem to find your email address in our system. Sorry about that!");
					logAudit.setResult(LogAudit.Result.FAIL);
					metadata = "token: " + resetId + ", emailMasterId: " + emailMasterId + ", no email address was found for the emailMasterId";
				}
			} catch (DaoException | GeneralSecurityException e) {
				response = createResponse("ERROR", "Oops, something seems to have gone wrong! - Please try the reset proceedure again later.");
				logAudit.setResult(LogAudit.Result.FAIL);
				metadata = "token: " + resetId + ", emailMasterId: " + emailMasterId + ", exception was thrown " + e.getMessage();
				logger.error(e);
			}
		} else {
			// JSON result failure - no email master ID was returned
			response = createResponse("INVALID_LINK", "Oops! Your reset password link has expired. Sorry about that.");
			logAudit.setResult(LogAudit.Result.FAIL);
			metadata = "token: " + resetId + ", no email master result was returned";
		}
		return response;
	}

	private JSONObject updatePassword(LogAudit logAudit, String resetId,
			String resetPassword,
			EmailMasterDao emailMasterDao,
			EmailMaster emailMaster) throws GeneralSecurityException,
			DaoException, JSONException {
		JSONObject response;
		logger.info("emailAddressSQL returned: " + emailMaster.getEmailAddress());
		String newPassword = StringEncryption.encryptNoKey(emailMaster.getEmailAddress().toLowerCase() + resetPassword + brandCode.toLowerCase());
		emailMaster.setPassword(newPassword);
		int sqlUpdateCode = emailMasterDao.updatePassword(emailMaster);
		if	(sqlUpdateCode == 1) {
			// JSON result success
			response = createResponse("OK", "");
			response.put("email", emailMaster.getEmailAddress());
			
			logAudit.setResult(LogAudit.Result.SUCCESS);
			identity = emailMaster.getEmailAddress();
		} else {
			// JSON result failure -the SQL update died
			response = createResponse("DB_ERROR", "Oops, something seems to have gone wrong! - Please try the reset proceedure again later.");
			logAudit.setResult(LogAudit.Result.FAIL);
			metadata = "token: " + resetId + ", emailMasterId: " + emailMaster.getEmailId() + ", the sqlUpdateCode indicated failure";
		}
		return response;
	}

	private JSONObject missingArguments(LogAudit logAudit) throws JSONException {
		logAudit.setResult(LogAudit.Result.FAIL);
		String message = "Oops, something seems to have gone wrong! - Check that you have provided a new password, or request a new reset password email.";
		return createResponse("INVALID_TOKEN_OR_PASSWORD", message);
	}

	private JSONObject createResponse(String result, String message) throws JSONException {
		JSONObject response = new JSONObject();
		response.put("result", result);
		response.put("message", message);
		return response;
	}
}
