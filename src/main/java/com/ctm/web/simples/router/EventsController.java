package com.ctm.web.simples.router;

import com.ctm.schema.health.v1_0_0.SimplesQuoteEvent;
import com.ctm.web.core.confirmation.services.DirectToCloudwatchEventsSender;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.simples.model.Event;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

@RestController
@RequestMapping("/rest/simples/events")
public class EventsController extends CommonQuoteRouter {

    @Autowired
    private DirectToCloudwatchEventsSender cloudWatchNotifier;

    @Autowired
    public EventsController(final SessionDataServiceBean sessionDataServiceBean, IPAddressHandler ipAddressHandler) {
        super(sessionDataServiceBean, ipAddressHandler);
    }

    @RequestMapping(
            value = "/sendEvent.json",
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_JSON_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public void sendEvent(@Valid @RequestBody Event event, HttpServletRequest request) throws DaoException {
        SimplesQuoteEvent simplesQuoteEvent = new SimplesQuoteEvent()
                .withGaId(event.getGaId())
                .withRootTransactionId(event.getRootId())
                .withTransactionId(event.getTransactionId())
                .withStep(event.getStep())
                .withSource("simples-journey-event");
        cloudWatchNotifier.send(simplesQuoteEvent, request.getRequestURL());
    }

}
