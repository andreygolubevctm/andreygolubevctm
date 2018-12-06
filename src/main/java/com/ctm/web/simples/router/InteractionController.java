package com.ctm.web.simples.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.InteractionService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.phone.inin.InInIcwsService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import rx.schedulers.Schedulers;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/rest/simples")
public class InteractionController extends CommonQuoteRouter {

    private static final Logger LOGGER = LoggerFactory.getLogger(InteractionController.class);

    private InInIcwsService inInIcwsService;
    private InteractionService interactionService;

    @Autowired
    public InteractionController(SessionDataServiceBean sessionDataServiceBean, InInIcwsService inInIcwsService, IPAddressHandler ipAddressHandler, InteractionService interactionService) {
        super(sessionDataServiceBean, ipAddressHandler);
        this.inInIcwsService = inInIcwsService;
        this.interactionService = interactionService;
    }

    @RequestMapping(
            value = "/storeCallDetail.json",
            method = RequestMethod.POST,
            consumes = MediaType.ALL_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public String storeCallDetails(@RequestParam("transactionId") final String transactionId, HttpServletRequest request, HttpServletResponse response) throws ConfigSettingException, DaoException, ServletException {
        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH");
        final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", pageSettings.getSetting("inInEnabled"));
        Integer transId = null;

        try{
            transId = Integer.parseInt(request.getParameter("transactionId"));
        }catch(NumberFormatException e){
            LOGGER.error("Unable to parse TransactionId={} ", transactionId);
        }

        if (inInEnabled &&  null != transId) {
            AuthenticatedData authenticatedData = sessionDataServiceBean.getAuthenticatedSessionData(request);
            if (authenticatedData != null && authenticatedData.getUid() != null) {
                String callId = inInIcwsService.getCallId(authenticatedData.getUid()).observeOn(Schedulers.io()).toBlocking().first();
                if(null != callId && !callId.equals("No value present")) {
                    interactionService.persistInteractionId(transId, callId);
                    return "Success. Call Details are stored for the transaction" + transactionId;
                } else {
                    LOGGER.info("No call Id exists for the user:" + authenticatedData.getUid());
                }
            }
        }
       return "Failed to store callId for the transaction"+ transactionId;
    }
}
