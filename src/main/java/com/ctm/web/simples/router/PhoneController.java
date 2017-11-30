package com.ctm.web.simples.router;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.InteractionService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.simples.phone.inin.InInIcwsService;
import com.ctm.web.simples.phone.inin.model.PauseResumeResponse;
import com.ctm.web.simples.phone.verint.VerintPauseResumeService;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import rx.schedulers.Schedulers;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.simples.router.PhoneController.pauseResumeActions.PauseRecord;
import static com.ctm.web.simples.router.PhoneController.pauseResumeActions.ResumeRecord;

@RestController
@RequestMapping("/rest/simples")
public class PhoneController extends CommonQuoteRouter {
    private static final Logger LOGGER = LoggerFactory.getLogger(PhoneController.class);

    enum pauseResumeActions {
        PauseRecord,
        ResumeRecord
    }

    private InInIcwsService inInIcwsService;
    private InteractionService interactionService;

    @Autowired
    public PhoneController(SessionDataServiceBean sessionDataServiceBean, InInIcwsService inInIcwsService, IPAddressHandler ipAddressHandler, InteractionService interactionService ) {
        super(sessionDataServiceBean, ipAddressHandler);
        this.inInIcwsService = inInIcwsService;
        this.interactionService = interactionService;
    }

    @RequestMapping(
        value = "/pauseResumeCall.json",
        method = RequestMethod.GET,
        consumes = MediaType.ALL_VALUE,
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    public PauseResumeResponse pauseResumeCall(@RequestParam pauseResumeActions action, HttpServletRequest request, HttpServletResponse response) throws ConfigSettingException, DaoException, ServletException {
        final VerintPauseResumeService verintPauseResumeService = new VerintPauseResumeService();
        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH");

        final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", pageSettings.getSetting("inInEnabled"));
        PauseResumeResponse pauseResumeResponse = PauseResumeResponse.fail("Failed");
        Integer transactionId =null;

        if(null != request.getParameter("transactionId")) {
            try{
                transactionId = Integer.parseInt(request.getParameter("transactionId"));
            }catch(NumberFormatException e){
                LOGGER.error("Unable to parse TransactionId={} ", transactionId);
            }
        }
        // Logic if we're using the InIn dialler
        if (inInEnabled) {
            String authName = null;
            if (request.getSession() != null) {
                AuthenticatedData authenticatedData = getSessionDataServiceBean().getAuthenticatedSessionData(request);
                if (authenticatedData != null) {
                    authName = authenticatedData.getUid();
                }
            }
            if (StringUtils.isEmpty(authName)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return PauseResumeResponse.fail("Unauthorised to access this feature");
            } else {
                if (action == PauseRecord) {
                    pauseResumeResponse = inInIcwsService.pause(authName, Optional.empty()).observeOn(Schedulers.io()).toBlocking().first();
                      if(null != transactionId && null != pauseResumeResponse.getInteractionId()) {
                          interactionService.persistInteractionId(transactionId, pauseResumeResponse.getInteractionId());
                      }
                } else if (action == ResumeRecord) {
                    pauseResumeResponse = inInIcwsService.resume(authName, Optional.empty()).observeOn(Schedulers.io()).toBlocking().first();
                    if(null != transactionId && null != pauseResumeResponse.getInteractionId()) {
                        interactionService.persistInteractionId(transactionId, pauseResumeResponse.getInteractionId());
                    }
                }
            }
        // Normal Verint telephony system
        } else {
            // Verint service throws exceptions which will be caught by our handleException()
            verintPauseResumeService.pauseResumeRecording(request, pageSettings);
            pauseResumeResponse = PauseResumeResponse.success();
        }

        if (!pauseResumeResponse.isSuccess()) {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        }
        return pauseResumeResponse;
    }

    @RequestMapping(
            value = "/apiDiallerRecording",
            method = RequestMethod.GET,
            consumes = MediaType.ALL_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public PauseResumeResponse apiDiallerRecording(HttpServletRequest request, HttpServletResponse response) throws ConfigSettingException, DaoException, ServletException {
        final String postOperatorId = request.getParameter("operatorId");
        final String postAction = request.getParameter("action");
        PauseResumeResponse pauseResumeResponse;
        Boolean ininRequestMade = false;
        LOGGER.info("apiDiallerRecording, request made {}, {}. Request params will be converted to upperCase", kv("action", postAction), kv("operatorId", postOperatorId));

        if (StringUtils.isEmpty(postOperatorId)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            pauseResumeResponse = PauseResumeResponse.fail("GET request missing operatorId param");

        } else {
            if (StringUtils.isEmpty(postAction)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                pauseResumeResponse = PauseResumeResponse.fail("GET request missing action param");

            } else if (postAction.toUpperCase().equals("PAUSE")) {
                pauseResumeResponse = inInIcwsService.pause(postOperatorId.toUpperCase(), Optional.empty()).observeOn(Schedulers.io()).toBlocking().first();
                ininRequestMade = true;

            } else if (postAction.toUpperCase().equals("RESUME")) {
                pauseResumeResponse = inInIcwsService.resume(postOperatorId.toUpperCase(), Optional.empty()).observeOn(Schedulers.io()).toBlocking().first();
                ininRequestMade = true;

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                pauseResumeResponse = PauseResumeResponse.fail("Unknown action: " + postAction);

            }
        }

        // If we attempted to pause/resume call and we have a fail status us 503, else if one of the other conditions failed status = 400, else success!
        if (!pauseResumeResponse.isSuccess() && ininRequestMade) {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            LOGGER.error("apiDiallerRecording, pauseResumeResponse failed with {}", kv("errors", pauseResumeResponse.getErrors().getMessage()));

        } else if (!pauseResumeResponse.isSuccess() && !ininRequestMade) {
            LOGGER.error("apiDiallerRecording, pauseResumeResponse failed with {}", kv("errors", pauseResumeResponse.getErrors().getMessage()));

        else {
            LOGGER.info("apiDiallerRecording, pauseResumeResponse success {}", kv("interactionId", pauseResumeResponse.getInteractionId()));

        }
        return pauseResumeResponse;
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final Exception e) {
        LOGGER.error("Failed to handle request", e);
        ErrorInfo errorInfo = new ErrorInfo();
        LoggingVariables.getTransactionId().ifPresent(t -> errorInfo.setTransactionId(t.get()));
        errorInfo.setErrors(Collections.singletonMap("message", e.getMessage()));
        return errorInfo;
    }
}