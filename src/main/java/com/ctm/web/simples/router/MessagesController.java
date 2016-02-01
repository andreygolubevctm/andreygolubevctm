package com.ctm.web.simples.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.dao.MessageDao;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.model.Postpone;
import com.ctm.web.simples.phone.inin.InInScheduleService;
import com.ctm.web.simples.services.MessageDetailService;
import com.ctm.web.simples.services.SimplesMessageService;
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
        final String postponeMessage = simplesMessageService.postponeMessage(simplesUid, postpone.getMessageId(), postpone.getStatusId(), postpone.getReasonStatusId(),
                postpone.getPostponeDate(), postpone.getPostponeTime(), postpone.getPostponeAMPM(), postpone.getComment(), postpone.getAssignToUser());

        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH");
        final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", pageSettings.getSetting("inInEnabled"));
        if (inInEnabled) {
            final MessageDao messageDao = new MessageDao();
            final Message message = messageDao.getMessage(postpone.getMessageId());
            inInScheduleService.scheduleCall(message, authenticatedData);
        }

        return postponeMessage;
    }

}
