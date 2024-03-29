package com.ctm.web.core.services;

import com.ctm.web.core.dao.LogAuditDao;
import com.ctm.web.core.model.LogAudit;
import com.ctm.web.core.security.StringEncryption;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.GeneralSecurityException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

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
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AuditService.class);
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
			LOGGER.error("Failed logging audit. {},{},{}", kv("logAudit", logAudit), kv("identity", identity),
				kv("metadata", metadata));
		}

		/*Run the log */
		LogAuditDao logAuditDao = new LogAuditDao();
		logAuditDao.writeLog(logAudit, priority, identity, "", finalData, brandCode + "-" + buildIdentifier, encryptedSessionId);
	}

}
