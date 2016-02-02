package com.ctm.web.simples.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.model.MessageDetail;
import com.ctm.web.simples.model.Postpone;
import com.ctm.web.simples.phone.inin.InInScheduleService;
import com.ctm.web.simples.services.SimplesMessageService;
import com.ctm.web.simples.services.TransactionService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.Date;

@RestController
@RequestMapping("/rest/simples/messages")
public class MessagesController extends CommonQuoteRouter {
    private static final Logger LOGGER = LoggerFactory.getLogger(MessagesController.class);
    private final InInScheduleService inInScheduleService;
    private final SimplesMessageService simplesMessageService;

    @Autowired
    public MessagesController(final SessionDataServiceBean sessionDataServiceBean, final InInScheduleService inInScheduleService) {
        super(sessionDataServiceBean);
        this.inInScheduleService = inInScheduleService;
        this.simplesMessageService = new SimplesMessageService();
    }

    @RequestMapping(
            value = "/setPostpone.json",
            method = RequestMethod.POST,
            consumes = MediaType.ALL_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public String setPostPone(@ModelAttribute Postpone postpone, HttpServletRequest request) throws ConfigSettingException, DaoException {
        AuthenticatedData authenticatedData = getSessionDataServiceBean().getAuthenticatedSessionData(request);
        final int simplesUid = authenticatedData.getSimplesUid();

        final PageSettings pageSettings = SettingsService.getPageSettingsByCode("CTM", Vertical.VerticalType.SIMPLES.getCode());
        final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", pageSettings.getSetting("inInEnabled"));

        final LocalDateTime postponeTo = getLocalDateTimeFromPostpone(postpone.getPostponeDate(), postpone.getPostponeTime(), postpone.getPostponeAMPM());
        final String postponeMessage = inInEnabled ? simplesMessageService.schedulePersonalMessage(simplesUid, postpone.getRootId(), postpone.getStatusId(), postponeTo, postpone.getContactName(), postpone.getComment()) : simplesMessageService.postponeMessage(simplesUid, postpone.getMessageId(), postpone.getStatusId(), postpone.getReasonStatusId(), postpone.getPostponeDate(), postpone.getPostponeTime(), postpone.getPostponeAMPM(), postpone.getComment(), postpone.getAssignToUser());

        if (inInEnabled) {
            final MessageDetail messageDetail = TransactionService.getTransaction(postpone.getRootId());
            Message message = messageDetail.getMessage();
            message.setWhenToAction(Date.from(postponeTo.toInstant(ZoneOffset.ofHours(10))));
            inInScheduleService.scheduleCall(message, authenticatedData.getUid());
        }

        return postponeMessage;
    }

    public LocalDateTime getLocalDateTimeFromPostpone(String postponeDate, String postponeTime, String postponeAMPM) {
        return LocalDateTime.parse(postponeDate + " " + postponeTime + " " + postponeAMPM, DateTimeFormatter.ofPattern("yyyy-MM-dd hh:mm a"));
    }

}
