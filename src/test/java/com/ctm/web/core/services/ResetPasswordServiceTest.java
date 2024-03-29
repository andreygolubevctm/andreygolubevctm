package com.ctm.web.core.services;

import com.ctm.web.core.dao.EmailMasterDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.LogAudit;
import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class ResetPasswordServiceTest {

	private int emailId;
	private String resetId;
	private LogAudit logAudit;
	private AuthenticationService authenticationService;
	private ResetPasswordService resetPasswordService;

	@Before
	public void setup() throws DaoException {
		emailId = 10;
		resetId = "Test Token";
		String emailAddress = "unit@unit.unit";
		
		EmailMasterDao emailMasterDao = mock(EmailMasterDao.class);
		EmailMaster emailMaster = new EmailMaster();
		emailMaster.setEmailId(emailId);
		emailMaster.setEmailAddress(emailAddress);
		when(emailMasterDao.getEmailMasterById(emailId)).thenReturn(emailMaster );
		when(emailMasterDao.updatePassword(emailMaster)).thenReturn(1);
		
		authenticationService = mock(AuthenticationService.class);
		AuditService auditService = mock(AuditService.class);
		resetPasswordService = new ResetPasswordService("ctm", authenticationService , emailMasterDao, auditService);
		when(authenticationService.verifyTokenForEmail(resetId)).thenReturn(-1);
		logAudit = new LogAudit();
		logAudit.setSessionId("10000");
	}
	
	@Test
	public void testShouldNotResetIfTokenHasExpired() throws JSONException, DaoException {
		when(authenticationService.verifyTokenForEmail(resetId)).thenReturn(-1);
		JSONObject result = resetPasswordService.reset(resetId, "test", logAudit );
		assertEquals("INVALID_LINK" ,result.getString("result"));
	}
	
	@Test
	public void testShouldResetIfTokenHasExpired() throws JSONException, DaoException {
		when(authenticationService.verifyTokenForEmail(resetId)).thenReturn(emailId);
		JSONObject result = resetPasswordService.reset(resetId, "test",logAudit );
		assertEquals("OK" ,result.getString("result"));
	}

}
