package com.ctm.web.core.confirmation.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.schema.event.v1_0_0.EventPublishRequest;
import com.ctm.schema.event.v1_0_0.Payload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Value;
import rx.schedulers.Schedulers;

import java.util.UUID;

@Component
public class DirectToCloudwatchEventsSender implements JoinNotificationSender {

    @Autowired
    private Client<EventPublishRequest, UUID> eventServiceClient;

    @Value("${event-broker.service.url}")
    private String eventBrokerUrl;

    @Override
    public void send(final Payload payload, final Object origin) {
        final EventPublishRequest request = new EventPublishRequest()
                .withPayload(payload)
                .withOrigin(origin);

        eventServiceClient.post(RestSettings.<EventPublishRequest>builder()
                .request(request)
                .jsonHeaders()
                .url(eventBrokerUrl)
                .responseType(MediaType.APPLICATION_JSON)
                .response(UUID.class)
                .build())
                .observeOn(Schedulers.io())
                .toBlocking()
                .single();
    }
}
