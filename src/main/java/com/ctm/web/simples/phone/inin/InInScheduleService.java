package com.ctm.web.simples.phone.inin;

import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.phone.inin.model.Identity;
import com.ctm.web.simples.services.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import rx.Observable;

import java.util.List;

import static rx.Observable.just;

@Service
public class InInScheduleService implements ScheduleService{

    @Autowired private InInApi inInApi;

    @Override
    public List<Message> scheduledCallList(final AuthenticatedData user) {
        return null;
    }

    @Override
    public boolean scheduleCall(final Message message, final AuthenticatedData user) {
        final Observable<Boolean> searchLead = inInApi.searchLead(message).toList()
            .flatMap(identities -> insert(message, identities));
        final Observable<Boolean> scheduleCall = searchLead.flatMap(ignore -> inInApi.updateScheduledCall(message, user));
        return scheduleCall.toBlocking().first();
    }

    private Observable<Boolean> insert(final Message message, final List<Identity> identities) {
        return identities.isEmpty() ? inInApi.insertLead(message) : just(Boolean.TRUE);
    }

    @Override
    public boolean deleteScheduledCall(final Message message, final AuthenticatedData user) {
        final Observable<Identity> searchLead = inInApi.searchLead(message);
        final Observable<Boolean> deleteScheduledCall = searchLead.flatMap(ignore -> inInApi.deleteScheduledCall(message));
        return deleteScheduledCall.toBlocking().first();
    }

}
