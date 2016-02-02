package com.ctm.web.simples.phone.inin;

import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.phone.inin.model.I3Identity;
import com.ctm.web.simples.services.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import rx.Observable;

import java.util.List;

@Service
public class InInScheduleService implements ScheduleService{

    @Autowired private InInApi inInApi;

    @Override
    public List<Message> scheduledCallList(final String agentUsername) {
        return null;
    }

    @Override
    public boolean scheduleCall(final Message message, final String agentUsername) {
        return inInApi.searchLead(message).toList()
                .flatMap(identities -> insertOrUpdateScheduledCall(message, agentUsername, identities)).toBlocking().first();
    }

    private Observable<Boolean> insertOrUpdateScheduledCall(final Message message, final String agentUsername, final List<I3Identity> identities) {
        if (identities.isEmpty()) {
            return inInApi.insertScheduledCall(message, agentUsername);
        } else {
            return inInApi.updateScheduledCall(message, agentUsername);
        }
    }

    @Override
    public boolean deleteScheduledCall(final Message message, final String agentUsername) {
        final Observable<I3Identity> searchLead = inInApi.searchLead(message);
        final Observable<Boolean> deleteScheduledCall = searchLead.flatMap(ignore -> inInApi.deleteScheduledCall(message));
        return deleteScheduledCall.toBlocking().first();
    }

}
