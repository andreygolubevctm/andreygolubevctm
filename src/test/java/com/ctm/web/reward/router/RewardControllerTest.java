package com.ctm.web.reward.router;

import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.reward.services.RewardService;
import org.junit.Test;

import java.time.ZoneId;
import java.time.ZonedDateTime;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;

public class RewardControllerTest {
	@Test
	public void roundupMinutes() throws Exception {
		RewardController rewardController = new RewardController(mock(SessionDataServiceBean.class), mock(IPAddressHandler.class), mock(RewardService.class));
		ZonedDateTime expected = ZonedDateTime.of(2017, 1, 16, 16, 0, 0, 0, ZoneId.of("UTC"));
		ZonedDateTime zdt = ZonedDateTime.of(2017, 1, 16, 16, 0, 15, 222, ZoneId.of("UTC"));
		assertEquals(expected.withMinute(0), rewardController.roundupMinutes(zdt.withMinute(0)));
		assertEquals(expected.withMinute(2), rewardController.roundupMinutes(zdt.withMinute(1)));
		assertEquals(expected.withMinute(2), rewardController.roundupMinutes(zdt.withMinute(2)));
		assertEquals(expected.withMinute(4), rewardController.roundupMinutes(zdt.withMinute(3)));
		assertEquals(expected.withMinute(0).withHour(17), rewardController.roundupMinutes(zdt.withMinute(59)));
	}

}