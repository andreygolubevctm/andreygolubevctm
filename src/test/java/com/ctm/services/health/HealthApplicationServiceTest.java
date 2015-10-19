package com.ctm.services.health;

import com.ctm.dao.health.HealthPriceDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Provider;
import com.ctm.model.Touch;
import com.ctm.model.health.Frequency;
import com.ctm.model.health.HealthPricePremium;
import com.ctm.model.settings.Vertical;
import com.ctm.security.token.JwtTokenCreator;
import com.ctm.security.token.config.TokenCreatorConfig;
import com.ctm.services.FatalErrorService;
import com.ctm.services.RequestService;
import com.ctm.services.SettingsService;
import com.ctm.utils.FormDateUtils;
import com.ctm.web.validation.health.HealthApplicationTokenValidation;
import com.disc_au.web.go.Data;
import org.junit.Before;
import org.junit.Test;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


public class HealthApplicationServiceTest {

	private static final String PREFIX = "health";
	private HealthApplicationService healthApplicationService;
	private Data data;
	private HealthPriceDao healthPriceDao;
	private HttpServletRequest request = mock(HttpServletRequest.class);
	private Date changeOverDate;
	private HttpSession session= mock(HttpSession.class);
	private RequestService requestService  = mock(RequestService.class);;
	private String sessionId = "sessionId";
	private Long transactionId= 1000L;
	private String secretKey = "secretKey";
	private String verticalCode = Vertical.VerticalType.HEALTH.getCode();
	private HealthApplicationTokenValidation tokenService = mock(HealthApplicationTokenValidation.class);
	private SettingsService settingsService;
	private TokenCreatorConfig config;

	@Before
	public void setup() throws Exception {
		settingsService = mock(SettingsService.class);
		Vertical vertical = mock(Vertical.class);
		when(vertical.getSettingValueForName("jwtSecretKey")).thenReturn(secretKey);
		when(settingsService.getVertical(verticalCode)).thenReturn(vertical);
		config = new TokenCreatorConfig();
		config.setVertical(verticalCode);

		when(tokenService.validateToken(anyObject())).thenReturn(true);
		when(request.getSession()).thenReturn(session);
		healthPriceDao = mock(HealthPriceDao.class);
		data = setupData();
		HealthPricePremium premiums = new HealthPricePremium();
		premiums.setMonthlyLhc(86.15);
		premiums.setMonthlyPremium(148.2);

		HealthPricePremium discPremiums = new HealthPricePremium();
		discPremiums.setMonthlyLhc(86.15);
		discPremiums.setMonthlyPremium(142.3);

		when(healthPriceDao.getPremiumAndLhc("545038", false)).thenReturn(premiums);
		when(healthPriceDao.getPremiumAndLhc("545038", true)).thenReturn(discPremiums);
		FatalErrorService fatalErrorService = mock(FatalErrorService.class);
		healthApplicationService = new HealthApplicationService(healthPriceDao, fatalErrorService, tokenService);
		healthApplicationService.setRequestService(requestService);

		setChangeOverDate();
	}

	public Data setupData() {
		Data data = new Data();
		data.put("health/loading", "0");
		data.put("health/rebate", "0");
		data.put(PREFIX + "/application/productId", "PHIO-HEALTH-545038");
		data.put(PREFIX + "/payment/details/frequency", Frequency.MONTHLY.getDescription());
		data.put(PREFIX + "/situation/healthCvr", "SM");
		data.put(PREFIX + "/payment/details/start", "27/11/2014");
		data.put(PREFIX + "/application/provider", "AUF");
		return data;
	}


	@Test
	public void testShouldRespondWithValidationResponse() throws  Exception {
		assertEquals("{\"result\":{\"success\":false,\"pendingID\":\"sessionId-1000\",\"errors\":{\"error\":{\"code\":\"Token Validation\",\"original\":\"Token Validation\"}}}}", healthApplicationService.createTokenValidationFailedResponse(transactionId, sessionId));
	}


	@Test
	public void shouldInitToken() throws JspException {
		when(session.getAttribute("callCentre")).thenReturn(false);

		Long transactionId= 1000L;
		config.setTouchType(Touch.TouchType.NEW);
		JwtTokenCreator jwtTokenCreator = new JwtTokenCreator(settingsService, config);
		String token = jwtTokenCreator.createToken("test", transactionId, 1000);
		when(requestService.getTransactionId()).thenReturn(transactionId);
		when(requestService.getToken()).thenReturn(token);
		when(tokenService.validateToken(anyObject())).thenReturn(true);
		healthApplicationService.setUpApplication(setupData(), request, changeOverDate);
		assertTrue(healthApplicationService.isValidToken());

	}

	@Test
	public void testShouldGetAmount() throws Exception {
		data.put("health/loading", "0");
		data.put("health/rebate", "0");
		Date changeOverDate = new Date();
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1707.6000000000001", paymentAmtResult);
		assertEquals("142.3", paymentFreqResult);
	}

	@Test
	public void testShouldGetAmountWithRebate() throws SQLException, Exception {
		data.put("health/loading", "0");
		data.put("health/rebate", "29.04");

		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("100.98" ,paymentFreqResult);
		assertEquals("1211.76" ,paymentAmtResult);
	}

	@Test
	public void testShouldGetAmountWithLHC() throws Exception {
		data.put("health/loading", "34");
		data.put("health/rebate", "0");
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("171.59" ,paymentFreqResult);
		assertEquals("2059.08" ,paymentAmtResult);
	}


	@Test
	public void testShouldGetAmountWithLHCandRebate() throws Exception {
		data.put("health/loading", "34");
		data.put("health/rebate", "29.04");
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1563.2400000000002" ,paymentAmtResult);
		assertEquals("130.27" ,paymentFreqResult);
	}

	@Test
	public void testShouldGetAmountWithLHCandRebateNib() throws SQLException, Exception {
		setupNib();
		//credit
		data.put("health/payment/details/type", "cc");

		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1506.6" ,paymentAmtResult);
		assertEquals("125.55" ,paymentFreqResult);
	}


	@Test
	public void testShouldGetAmountWithLHCandRebateNibBank() throws SQLException, Exception {
		setupNib();

		//bank
		data.put("health/payment/details/type", "ba");
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult = (String) data.get("health/application/paymentFreq");
		assertEquals("1459.92" ,paymentAmtResult);
		assertEquals("121.66" ,paymentFreqResult);
	}

	private void setupNib() throws DaoException, JspException {
		data.put("health/application/provider", "NIB");
		data.put("health/application/productId", "PHIO-HEALTH-563234");

		HealthPricePremium premiums = new HealthPricePremium();
		premiums.setMonthlyLhc(82.68);
		premiums.setMonthlyPremium(137.32);

		HealthPricePremium discPremiums = new HealthPricePremium();
		discPremiums.setMonthlyLhc(82.68);
		discPremiums.setMonthlyPremium(131.83);

		when(healthPriceDao.getPremiumAndLhc("563234", false)).thenReturn(premiums );
		when(healthPriceDao.getPremiumAndLhc("563234", true)).thenReturn(discPremiums );

		data.put("health/loading", "34");
		data.put("health/rebate", "29.04");

		//credit
		data.put("health/payment/details/type", "cc");

		healthApplicationService.setUpApplication(data, request, changeOverDate);
		String paymentAmtResult = (String) data.get("health/application/paymentAmt");
		String paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1506.6" ,paymentAmtResult);
		assertEquals("125.55" ,paymentFreqResult);

		//bank
		data.put("health/payment/details/type", "ba");
		data.put(PREFIX + "/payment/details/frequency", Frequency.MONTHLY.getDescription());
		healthApplicationService.setUpApplication(data, request, changeOverDate);
		paymentAmtResult = (String) data.get("health/application/paymentAmt");
		paymentFreqResult =  (String) data.get("health/application/paymentFreq");
		assertEquals("1459.92" ,paymentAmtResult);
		assertEquals("121.66" ,paymentFreqResult);
		data.put(PREFIX + "/payment/details/frequency", Frequency.MONTHLY.getDescription());

	}

	private void setChangeOverDate() {
		String changeOverDateString = "01/04/2015";
		this.changeOverDate = FormDateUtils.parseDateFromForm(changeOverDateString);
	}

	@Test
	public void shouldGetAllProviders() throws Exception {
		int styleCode = 0;
		List<Provider> providerList = new ArrayList<>();
		Provider provider = new Provider();
		providerList.add(provider);
		when(healthPriceDao.getAllProviders(styleCode)).thenReturn(providerList);
		List<Provider> result = healthApplicationService.getAllProviders(styleCode);
		assertEquals(providerList, result);

	}

}
