package com.ctm.web.email;

import com.ctm.httpclient.Client;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.email.integration.emailservice.EmailServiceClient;
import com.ctm.web.email.integration.emailservice.TokenRequest;
import com.ctm.web.email.integration.emailservice.TokenResponse;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import rx.Observable;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

import static com.ctm.interfaces.common.types.VerticalType.HOME;
import static com.ctm.web.email.integration.emailservice.EmailTokenAction.LOAD;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.springframework.test.util.ReflectionTestUtils.setField;

/**
 * Created by lna on 20/12/17.
 */
public class EmailServiceClientTest {

    @Mock
    private Client<List<TokenRequest>, List<TokenResponse>> client;

    @InjectMocks
    private EmailServiceClient emailServiceClient;

    @Before
    public void setup() {
        initMocks(this);
        setField(emailServiceClient, "baseUrl", "aBaseUrl");
        setField(emailServiceClient, "timeout", 30L);
    }

    @Test
    public void test() throws Exception {

        // mock
        when(client.post(any())).thenReturn(Observable.just(Arrays.asList(TokenResponse.newBuilder().url("www.my-test.com").build())));

        // a random transaction id
        final Integer aRandomStyleCodeId = new Random().nextInt();
        final Long aRandomTransactionId = new Random().nextLong();

        final EmailMaster emailMaster = new EmailMaster();
        emailMaster.setEmailAddress("my-test@test.com");
        emailServiceClient.createEmailToken(aRandomStyleCodeId, HOME, aRandomTransactionId, LOAD, emailMaster);

        // verifications
        verify(client).post(any());
    }
}
