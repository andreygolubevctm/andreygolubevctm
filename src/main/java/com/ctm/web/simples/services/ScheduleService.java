package com.ctm.web.simples.services;

import com.ctm.web.simples.model.Message;

import java.util.List;

public interface ScheduleService {

    boolean scheduleCall(final Message message, final String agentUsername);

    boolean deleteScheduledCall(final Message message, final String agentUsername);
}
