package com.ctm.web.core.router;

import com.ctm.web.core.model.HandoverConfirmation;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.HandoverConfirmationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.AsyncContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolation;
import javax.validation.Validation;
import javax.validation.Validator;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@WebServlet(asyncSupported = true, urlPatterns = {"/handover/confirm"})
public class HandoverConfirmationRouter extends HttpServlet {
	private static final Logger LOGGER = LoggerFactory.getLogger(HandoverConfirmationService.class);
    private final HandoverConfirmationService service = new HandoverConfirmationService();
    private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

    private ExecutorService executor;

    @Override
    public void init() throws ServletException {
        executor = Executors.newFixedThreadPool(10);
    }

    @Override
    public void destroy() {
        executor.shutdown();
    }

    @Override
    protected void doPost(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, IOException {
        final AsyncContext asyncContext = request.startAsync(request, response);
        executor.execute(() -> {
            response.setHeader("Access-Control-Allow-Origin", "*");
            response.setContentType("application/json");
            final String ip = IPAddressHandler.getInstance().getIPAddress(request);
            final boolean status = confirm(request.getParameterMap(), ip);
            writeResponse(response, status);
            asyncContext.complete();
        });
    }

    private void writeResponse(final HttpServletResponse response, final Boolean status) {
        try {
            final PrintWriter writer = response.getWriter();
            final String result = "{\"success\":" + status +"}";
            writer.print(result);
        } catch (final IOException e) {
            LOGGER.error("Failed to write handover server response {}", kv("status", status), e);
        }
    }

    private boolean confirm(final Map<String, String[]> parameterMap, final String ip) {
        try {
            final HandoverConfirmation handoverConfirmation = service.createConfirmation(parameterMap, ip);
            final Set<ConstraintViolation<HandoverConfirmation>> violations = validator.validate(handoverConfirmation);
            LOGGER.info("handover confirmation {}", kv("confirmation", handoverConfirmation));
            if (violations.isEmpty()) {
                service.confirm(handoverConfirmation);
                return true;
            } else {
                LOGGER.error("invalid parameters {}", kv("violations", violations));
                return false;
            }
        } catch (final Exception e) {
            LOGGER.error("error saving handover confirmation", e);
            return false;
        }
    }

}
