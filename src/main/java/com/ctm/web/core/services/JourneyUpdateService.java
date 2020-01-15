package com.ctm.web.core.services;

import java.math.BigDecimal;
import java.time.Instant;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.schema.messagequeue.v1_0_0.Header;
import com.ctm.schema.messagequeue.v1_0_0.MqMessage;
import com.ctm.schema.messagequeue.v1_0_0.Payload;
import com.ctm.schema.sessions.v1_0_0.Interaction;
import com.ctm.schema.sessions.v1_0_0.SessionUpdate;
import com.ctm.web.core.providers.model.Request;
import com.ctm.web.core.providers.model.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import rx.schedulers.Schedulers;

@Component
public class JourneyUpdateService {

    @Autowired
    private Client<Request<MqMessage>, Response<Object>> passthrough;
    private static final Logger LOGGER = LoggerFactory.getLogger(JourneyUpdateService.class);
    @Value("${ctm.nats-passthrough}")
    private String PASSTHROUGH_URL;
    private static final int TIMEOUT = 5000;

    public void publishInteraction(String source, String interactionId, String sessionId, String userId) {
        Request<MqMessage> msg = new Request<>();
        msg.setPayload(new MqMessage()
                .withHeader(new Header()
                        .withOrigin(source))
                .withPayload(new Payload()
                        .withAdditionalProperty("userId", userId)
                        .withAdditionalProperty("sessionId", sessionId)
                        .withAdditionalProperty("interaction", new Interaction()
                                .withSourceName(source)
                                .withLoggedIn((userId != null && !userId.equals("")))
                                .withInteractionId(interactionId)
                                .withCreatedAt(new BigDecimal(Instant.now().getEpochSecond()))
                        )));
        passthrough.post(RestSettings.<Request<MqMessage>>builder()
                .request(msg)
                .jsonHeaders()
                .url(PASSTHROUGH_URL)
                .timeout(TIMEOUT)
                .responseType(MediaType.APPLICATION_JSON)
                .response(Response.class)
                .build())
                .doOnError(this::logError)
                .observeOn(Schedulers.io()).toBlocking().single();
    }

    private void logError(Throwable e){
        LOGGER.error("problem posting to passthrough", e);
    }
}
