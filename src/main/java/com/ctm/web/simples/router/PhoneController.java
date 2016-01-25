package com.ctm.web.simples.router;

import com.ctm.commonlogging.context.LoggingVariables;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.phone.inin.InInIcwsService;
import com.ctm.web.simples.phone.verint.VerintPauseResumeService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import java.util.Collections;


@RestController
@RequestMapping("/rest/simples")
public class PhoneController extends CommonQuoteRouter {
    private static final Logger LOGGER = LoggerFactory.getLogger(PhoneController.class);

    private InInIcwsService inInIcwsService;

    @Autowired
    public PhoneController(SessionDataServiceBean sessionDataServiceBean, InInIcwsService inInIcwsService) {
        super(sessionDataServiceBean);
        this.inInIcwsService = inInIcwsService;
    }

    @RequestMapping(
        value = "/pauseResumeCall.json",
        method = RequestMethod.GET,
        consumes = MediaType.ALL_VALUE,
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    public void pauseResumeCall(String action, HttpServletRequest request) throws ConfigSettingException, DaoException, ServletException {
        final VerintPauseResumeService verintPauseResumeService = new VerintPauseResumeService();
        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH");

        final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", pageSettings.getSetting("inInEnabled"));

        if (inInEnabled) {
            inInIcwsService.pause();
        } else {
            verintPauseResumeService.pauseResumeRecording(request, pageSettings);
        }
    }

    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final Exception e) {
        LOGGER.error("Failed to handle request", e);
        ErrorInfo errorInfo = new ErrorInfo();
        LoggingVariables.getTransactionId().ifPresent(t -> errorInfo.setTransactionId(t.get()));
        errorInfo.setErrors(Collections.singletonMap("error", e.getMessage()));
        return errorInfo;
    }
}