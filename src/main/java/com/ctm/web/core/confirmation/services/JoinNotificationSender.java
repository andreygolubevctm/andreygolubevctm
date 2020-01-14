package com.ctm.web.core.confirmation.services;

import com.ctm.schema.event.v1_0_0.Payload;

public interface JoinNotificationSender {

    void send(Payload payload, Object origin);
}
