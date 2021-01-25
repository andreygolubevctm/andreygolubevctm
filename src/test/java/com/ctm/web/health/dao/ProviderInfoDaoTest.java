package com.ctm.web.health.dao;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mockito;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import javax.validation.constraints.AssertTrue;
import java.util.Date;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Created by msmerdon on 16/1/21.
 */
public class ProviderInfoDaoTest {

	private NamedParameterJdbcTemplate jdbcTemplate;
	private ProviderInfoDao providerInfoDao;
	private ProviderInfoDao providerInfoDaoSpy;
	private Provider provider;
	private Brand brand;
	private Date searchDate;

	private final int providerId = 666;
	private final String providerCode = "123456";
	private final String providerName = "Cornholeo";
	private final String providerEmail = "email@fake.org";
	private final String providerWebsite = "www.fake.org";
	private final String providerPhoneNumber = "1300 666 000";
	private final String providerDirectPhoneNumber = "13 11 55";

	@Before
	public void setup() {
		brand = mock(Brand.class);
		searchDate = new Date();
		jdbcTemplate = mock(NamedParameterJdbcTemplate.class);
		providerInfoDao = new ProviderInfoDao(jdbcTemplate);
		providerInfoDaoSpy = Mockito.spy(providerInfoDao);
		provider = new Provider();
		provider.setCode(providerCode);
		provider.setId(providerId);
		provider.setName(providerName);
		provider.setPropertyDetail("mobile", providerPhoneNumber);
		provider.setPropertyDetail("email", providerEmail);

		when(brand.getId()).thenReturn(1);
		doReturn(Optional.of(providerEmail)).when(providerInfoDaoSpy).getProviderContent(provider, brand, searchDate, "providerEmail");
		doReturn(Optional.of(providerWebsite)).when(providerInfoDaoSpy).getProviderContent(provider, brand, searchDate, "providerWebsite");
		doReturn(Optional.of(providerDirectPhoneNumber)).when(providerInfoDaoSpy).getProviderContent(provider, brand, searchDate, "providerDirectPhoneNumber");
	}

	@Test
	public void testGetProviderInfo() {
		ProviderInfo providerInfo = providerInfoDaoSpy.getProviderInfo(provider, brand, searchDate);
		ProviderInfo comparitor = ProviderInfo.newProviderInfo()
			.email(providerEmail)
			.phoneNumber(providerDirectPhoneNumber)
			.website(providerWebsite)
			.build();

		assertEquals(comparitor.getEmail(), providerInfo.getEmail());
		assertEquals(comparitor.getPhoneNumber(), providerInfo.getPhoneNumber());
		assertEquals(comparitor.getWebsite(), providerInfo.getWebsite());
	}
}
