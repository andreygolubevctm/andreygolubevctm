package com.ctm.services;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Date;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;

import com.ctm.dao.SessionTokenDao;
import com.ctm.dao.TouchDao;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.TokenSecurityException;
import com.ctm.model.Touch;
import com.ctm.model.session.SessionToken;
import com.ctm.security.StringEncryption;
import com.disc_au.web.LDAPDetails;

public class AuthenticationService {

	@SuppressWarnings("unused")
	private static Logger logger = Logger.getLogger(AuthenticationService.class.getName());

	/**
	 * Generate a token for a simples users. This is using their LDAP user id.
	 *
	 * @param uid
	 * @return
	 * @throws DaoException
	 * @throws NoSuchAlgorithmException
	 * @throws InvalidKeyException
	 */
	public static String generateTokenForSimplesUser(String uid) throws DaoException, InvalidKeyException, NoSuchAlgorithmException {
		return generateLastTouchToken(SessionToken.IdentityType.LDAP, uid, null);
	}

	/**
	 * Authenticate a user using a token - creates a databucket for the user as if they logged in.
	 * This doesn't replace the Tomcat Security layer so the user is not 'fully' logged in, but have enough in their databucket
	 * to make their way through a journey.
	 *
	 * @param session
	 * @param token
	 * @return
	 * @throws DaoException
	 * @throws Exception
	 */
	public static boolean authenticateWithTokenForSimplesUser(HttpSession session, String token) throws DaoException {
		String uid = AuthenticationService.consumeLastTouchToken(SessionToken.IdentityType.LDAP, token);

		if (uid != null) {
			getUserDetailsFromLdap(session, uid);
			// These would have been set in the login tag but because we are not using proper JSESSION log in they are not.
			session.setAttribute("isLoggedIn", true);
			session.setAttribute("callCentre", true);
			return true;
		}
		else {
			throw new TokenSecurityException("Token mismatch");
		}
	}

	/**
	 * Generate a token using the most recent transaction id for a record the email master table.
	 * If the transaction id is null, the current date will be used as reference.
	 *
	 * @param emailMasterId
	 * @param transactionId
	 * @return
	 * @throws Exception
	 */
	public static String generateTokenForEmail(int emailMasterId, String transactionId) throws Exception{
		return generateLastTouchToken(SessionToken.IdentityType.EMAIL_MASTER, Integer.toString(emailMasterId), transactionId);
	}

	/**
	 * Consume and verify a token which was generated for a record in email master.
	 *
	 * @param token
	 * @return
	 */
	public static String verifyTokenForEmail(String token){

		try {
			return AuthenticationService.consumeLastTouchToken(SessionToken.IdentityType.EMAIL_MASTER, token);
		} catch (Exception e) {
			return null;
		}

	}

	/**
	 * Generate a token for a user.
	 * Uses the last touch date time from the database to try and create a unique token (with fall back for new users with no touches)
	 *
	 * @param identityType
	 * @param identityValue
	 * @param transactionId
	 * @return
	 * @throws DaoException
	 * @throws NoSuchAlgorithmException
	 * @throws InvalidKeyException
	 */
	private static String generateLastTouchToken(SessionToken.IdentityType identityType, String identityValue, String transactionId) throws DaoException, InvalidKeyException, NoSuchAlgorithmException {

		TouchDao touchDao = new TouchDao();
		Touch touch = null;

		// Different rules for Simples users v. regular customers
		if(identityType == SessionToken.IdentityType.LDAP){
			touch = touchDao.getLatestByOperatorId(identityValue);
		}else if(identityType == SessionToken.IdentityType.EMAIL_MASTER && transactionId != null){
			touch = touchDao.getLatestByTransactionId(transactionId);
		}

		// If no transaction id for customer, or if new simples user, just use now.
		Date date = new Date();

		if(touch != null){
			date = touch.getDatetime();
		}

		// Generate token

		StringEncryption encryption = new StringEncryption();
		Date now = new Date();
		String encrypted = encryption.encrypt(identityValue+date.getTime()+now.getTime());

		String token = encrypted;

		SessionToken sessionToken = new SessionToken();
		sessionToken.setToken(token);
		sessionToken.setIdentityType(identityType);
		sessionToken.setIdentity(identityValue);

		SessionTokenDao sessionTokenDao = new SessionTokenDao();
		sessionTokenDao.addToken(sessionToken);

		return token;

	}

	/**
	 * Consumes a token generated. Only can consume tokens which are less than 5 minutes old and have not previously been consumed.
	 *
	 * @param identityType
	 * @param token
	 * @return
	 * @throws DaoException
	 * @throws Exception
	 */
	private static String consumeLastTouchToken(SessionToken.IdentityType identityType, String token) throws DaoException {

		SessionTokenDao sessionTokenDao = new SessionTokenDao();
		SessionToken sessionToken = sessionTokenDao.getToken(token, identityType);

		if(sessionToken != null){
			sessionTokenDao.consumeToken(sessionToken);
			return sessionToken.getIdentity();
		}else{
			throw new TokenSecurityException("Unable to consume token.");
		}

	}



	/**
	 * Look up ldap for user details and set the correct session scoped variable.
	 *
	 * @param session
	 * @param uid
	 * @return
	 * @throws Exception
	 */
	public static LDAPDetails getUserDetailsFromLdap(HttpSession session, String uid) {

		LDAPDetails ldapDetails = new LDAPDetails(uid);

		// These session scoped variables are used by the core:login tag to set up the authenticated data bucket.
		session.setAttribute("userDetails", ldapDetails.getDetails());

		return ldapDetails;

	}

}
