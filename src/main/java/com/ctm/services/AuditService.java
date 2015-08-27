package com.ctm.services;

import java.security.GeneralSecurityException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

import com.ctm.security.StringEncryption;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ctm.dao.LogAuditDao;
import com.ctm.model.LogAudit;

/**
 * Inspiration:
	https://www.owasp.org/index.php/Logging_Cheat_Sheet
	http://stackoverflow.com/questions/549/the-definitive-guide-to-form-based-website-authentication#477585
	@example:
	// failed password attempt from invalid token, could include the token used, and a priority should be notice.
	<security:log_audit identity="email@host.com" action="RESET PASSWORD" result="FAIL" description="Invalid Reset Token" metadata="<token>${token}</token>" priority="5" />

	Priority Codes
	EMERG   = 0;  // Emergency: system is unusable
	ALERT   = 1;  // Alert: action must be taken immediately
	CRIT    = 2;  // Critical: critical conditions
	ERR     = 3;  // Error: error conditions
	WARN    = 4;  // Warning: warning conditions
	NOTICE  = 5;  // Notice: normal but significant condition
	INFO    = 6;  // Informational: informational messages
	DEBUG   = 7;  // Debug: debug messages
 *
 */
public class AuditService {
	
	private static final Logger logger = LoggerFactory.getLogger(AuditService.class.getName());
	private String brandCode;
	
	public AuditService(String brandCode) {
		this.brandCode = brandCode;
	}
	
	public void logAudit(LogAudit logAudit, String identity,
			String metadata) {
		int priority = 6;
		/* Add more meta data to the data variable */
		String finalData ="<data>" + metadata + "<server><ua>" + logAudit.getUserAgent() + "</ua></server></data>";
		/* Import Manifest to grab buildIdentifier */
		String buildIdentifier = EnvironmentService.getBuildIdentifier();

		/*OWASP recommends never storing session ids unencrypted */
		String secret_key = "7T7XVh0U6mJ7JNzcZX1e-2";
		String encryptedSessionId = null;
		try {
			encryptedSessionId = StringEncryption.encrypt(secret_key, logAudit.getSessionId());
		} catch (GeneralSecurityException e) {
			logger.error("",e);
		}

		/*Run the log */
		LogAuditDao logAuditDao = new LogAuditDao();
		logAuditDao.writeLog(logAudit, priority, identity, "", finalData, brandCode + "-" + buildIdentifier, encryptedSessionId);
	}

}
