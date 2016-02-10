package com.ctm.web.simples.services;

import com.ctm.web.simples.model.Message;
import rx.Observable;

public interface ScheduleService {
    Observable<Boolean> scheduleCall(final Message message, final String agentUsername);
    Observable<Boolean> deleteScheduledCall(final Message message, final String agentUsername);
}
