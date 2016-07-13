package com.ctm.web.simples.phone.inin;

import com.ctm.httpclient.Client;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.phone.inin.model.ConnectionReq;
import com.ctm.web.simples.phone.inin.model.ConnectionResp;
import com.ctm.web.simples.phone.inin.model.PauseResumeResponse;
import org.junit.Test;
import rx.Observable;

import java.net.UnknownHostException;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

public class InInIcwsServiceTest {

	@Test
	public void testPauseFailover() throws Exception {
		InInConfig configMock = mock(InInConfig.class);
		when(configMock.getCicPrimaryUrl()).thenReturn("primaryUrl");
		when(configMock.getCicFailoverUrl()).thenReturn("secondaryUrl");

		Client<ConnectionReq, ConnectionResp> connectionClientMock = mock(Client.class);
		when(connectionClientMock.postWithResponseEntity(any())).thenReturn(Observable.error(new UnknownHostException("Exception")));

		InInIcwsService inInIcwsService = new InInIcwsService(mock(SerializationMappers.class), configMock,
				connectionClientMock, mock(Client.class), mock(Client.class), mock(Client.class));

		Observable<PauseResumeResponse> pause = inInIcwsService.pause("agent", Optional.empty());

		assertEquals(false, pause.toBlocking().first().isSuccess());
		verify(connectionClientMock, times(2)).postWithResponseEntity(any());
	}

}