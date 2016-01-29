package com.ctm.web.simples.services;

import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.simples.model.Message;

import java.util.List;

public interface ScheduleService {

    List<Message> scheduledCallList(final AuthenticatedData user);

    boolean scheduleCall(final Message message, final AuthenticatedData user);

    boolean deleteScheduledCall(final Message message, final AuthenticatedData user);
}
