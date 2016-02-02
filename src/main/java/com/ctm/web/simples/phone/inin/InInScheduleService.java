package com.ctm.web.simples.phone.inin;

import com.ctm.web.core.model.session.AuthenticatedData;
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
    public List<Message> scheduledCallList(final AuthenticatedData user) {
        return null;
    }

    @Override
    public boolean scheduleCall(final Message message, final AuthenticatedData user) {
        return inInApi.searchLead(message).toList()
            .flatMap(identities -> insertOrUpdateScheduledCall(message, user, identities)).toBlocking().first();
    }

    private Observable<Boolean> insertOrUpdateScheduledCall(final Message message, final AuthenticatedData user, final List<I3Identity> identities) {
        if (identities.isEmpty()) {
            return inInApi.insertScheduledCall(message, user);
        } else {
            return inInApi.updateScheduledCall(message, user);
        }
    }

    @Override
    public boolean deleteScheduledCall(final Message message, final AuthenticatedData user) {
        final Observable<I3Identity> searchLead = inInApi.searchLead(message);
        final Observable<Boolean> deleteScheduledCall = searchLead.flatMap(i3Identity -> inInApi.deleteScheduledCall(i3Identity));
        return deleteScheduledCall.toBlocking().first();
    }

}
