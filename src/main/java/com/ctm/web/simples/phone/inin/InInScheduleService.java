package com.ctm.web.simples.phone.inin;

import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.phone.inin.model.Identity;
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
        //Check for existence of user/lead
        Observable<Identity> identity = inInApi.searchScheduledCall(message);

        //Create user/lead if does not exist

        //Schedule call time. Note that this may update an existing scheduled call
        return false;
    }

    @Override
    public boolean deleteScheduledCall(final Message message, final AuthenticatedData user) {
        inInApi.searchScheduledCall(message);

//        inInApi.deleteScheduledCall(identity);
        return false;
    }

    protected void insert(){

    }

}
