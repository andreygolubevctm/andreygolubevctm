package com.ctm.web.simples.phone.inin;

import com.ctm.httpclient.Client;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.core.services.InteractionService;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.phone.inin.model.RecordSnippetResponse;
import com.ctm.web.simples.phone.inin.model.ConnectionReq;
import com.ctm.web.simples.phone.inin.model.ConnectionResp;
import com.ctm.web.simples.phone.inin.model.PauseResumeResponse;
import org.junit.Before;
import org.junit.Test;
import rx.Observable;

import java.net.UnknownHostException;
import java.util.Optional;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.*;

public class InInIcwsServiceTest {
    InInConfig config;


    @Before
    public void setUp() {
        config = mock(InInConfig.class);
    }


    @Test
    public void testPauseFailover() throws Exception {
        when(config.getCicPrimaryUrl()).thenReturn("primaryUrl");
        when(config.getCicFailoverUrl()).thenReturn("secondaryUrl");

        Client<ConnectionReq, ConnectionResp> connectionClientMock = mock(Client.class);
        when(connectionClientMock.postWithResponseEntity(any())).thenReturn(Observable.error(new UnknownHostException("Exception")));

        InInIcwsService inInIcwsService = new InInIcwsService(mock(InteractionService.class), mock(SerializationMappers.class), config,
                connectionClientMock, mock(Client.class), mock(Client.class), mock(Client.class), mock(Client.class),mock(Client.class));

        Observable<PauseResumeResponse> pause = inInIcwsService.pause("agent", Optional.empty());

        assertEquals(false, pause.toBlocking().first().isSuccess());
        verify(connectionClientMock, times(2)).postWithResponseEntity(any());
    }


    @Test
    public void testRecordSnippingFailover() throws Exception {
        InInConfig config = mock(InInConfig.class);
        when(config.getCicPrimaryUrl()).thenReturn("primaryUrl");
        when(config.getCicFailoverUrl()).thenReturn("secondaryUrl");

        Client<ConnectionReq, ConnectionResp> connectionClientMock = mock(Client.class);
        when(connectionClientMock.postWithResponseEntity(any())).thenReturn(Observable.error(new UnknownError("Unknown host exception")));

        InInIcwsService inInIcwsService = new InInIcwsService(mock(InteractionService.class), mock(SerializationMappers.class), config,
                connectionClientMock, mock(Client.class), mock(Client.class), mock(Client.class), mock(Client.class),mock(Client.class));

        Observable<RecordSnippetResponse> snip = inInIcwsService.recordSnippet("true", "false", "tack","123456789");

        assertEquals(false, snip.toBlocking().first().isSuccess());

        verify(connectionClientMock, times(1)).postWithResponseEntity(any());
    }
}