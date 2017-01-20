package com.ctm.web.reward.services;

import com.ctm.httpclient.Client;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import org.junit.Test;

import java.time.ZoneId;
import java.time.ZonedDateTime;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;

public class RewardServiceTest {
	@Test
	public void roundupMinutes() throws Exception {
		RewardService reward = new RewardService(mock(TransactionDetailsDao.class),
				mock(Client.class), mock(Client.class), mock(Client.class),
				mock(RewardCampaignService.class), mock(ApplicationService.class), mock(SessionDataServiceBean.class));
		ZonedDateTime expected = ZonedDateTime.of(2017, 1, 16, 16, 0, 0, 0, ZoneId.of("UTC"));
		ZonedDateTime zdt = ZonedDateTime.of(2017, 1, 16, 16, 0, 15, 222, ZoneId.of("UTC"));
		assertEquals(expected.withMinute(0), reward.roundupMinutes(zdt.withMinute(0)));
		assertEquals(expected.withMinute(2), reward.roundupMinutes(zdt.withMinute(1)));
		assertEquals(expected.withMinute(2), reward.roundupMinutes(zdt.withMinute(2)));
		assertEquals(expected.withMinute(4), reward.roundupMinutes(zdt.withMinute(3)));
		assertEquals(expected.withMinute(0).withHour(17), reward.roundupMinutes(zdt.withMinute(59)));
	}

}