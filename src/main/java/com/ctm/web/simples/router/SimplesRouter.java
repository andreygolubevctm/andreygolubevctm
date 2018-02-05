package com.ctm.web.simples.router;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.CrudValidationException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.AccessCheckService;
import com.ctm.web.core.services.FatalErrorService;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.validation.SchemaValidationError;
import com.ctm.web.simples.admin.openinghours.services.OpeningHoursAdminService;
import com.ctm.web.simples.admin.router.AdminRouter;
import com.ctm.web.simples.admin.services.HelpBoxService;
import com.ctm.web.simples.admin.services.SpecialOffersService;
import com.ctm.web.simples.admin.services.SpecialOptInService;
import com.ctm.web.simples.dao.UserDao;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.phone.verint.CtiPhoneService;
import com.ctm.web.simples.services.SimplesMessageService;
import com.ctm.web.simples.services.SimplesTickleService;
import com.ctm.web.simples.services.SimplesUserService;
import com.ctm.web.simples.services.TransactionService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.simples.phone.verint.CtiPhoneService.makeCall;
import static java.lang.Integer.parseInt;
import static java.util.Collections.singletonList;
import static javax.servlet.http.HttpServletResponse.*;

@WebServlet(urlPatterns = {
        "/simples/comments/list.json",
        "/simples/messages/get.json",
        "/simples/messages/next.json",
        "/simples/messages/postponed.json",//anything in the future scheduled for the current user
        "/simples/tickle.json",
        "/simples/transactions/lock.json",
        "/simples/transactions/unlock.json",
        "/simples/transactions/details.json",
        "/simples/users/list_online.json",
        "/simples/users/stats_today.json",
        "/simples/phones/call.json",
        "/general/phones/callInfo/get.json",
        "/simples/admin/openinghours/update.json",
        "/simples/admin/openinghours/create.json",
        "/simples/admin/openinghours/delete.json",
        "/simples/admin/openinghours/getAllRecords.json",
        "/simples/admin/offers/update.json",
        "/simples/admin/offers/create.json",
        "/simples/admin/offers/delete.json",
        "/simples/admin/offers/getAllRecords.json",
        "/simples/admin/helpbox/update.json",
        "/simples/admin/helpbox/create.json",
        "/simples/admin/helpbox/delete.json",
        "/simples/admin/helpbox/getAllRecords.json",
        "/simples/admin/helpbox/getCurrentRecords.json",
        "/simples/admin/specialOptIn/update.json",
        "/simples/admin/specialOptIn/getAllRecords.json",
        "/simples/admin/providerContent/getAllRecords.json",
        "/simples/admin/providerContent/update.json",
        "/simples/admin/providerContent/create.json",
        "/simples/admin/providerContent/delete.json",
        // post
        "/simples/admin/cappingLimits/update.json",
        "/simples/admin/cappingLimits/create.json",
        "/simples/admin/cappingLimits/delete.json",
        "/simples/admin/cappingLimits.json",
        "/simples/admin/productCappingLimits/create.json",
        "/simples/admin/productCappingLimits/update.json",
        "/simples/admin/productCappingLimits/delete.json",
        "/simples/admin/productCappingLimits/getAllRecords.json",
        //get
        "/simples/admin/cappingLimits/getAllRecords.json",
        "/simples/transaction/get.json",
        "/simples/admin/productCappingLimits/getSummary.json"
})
public class SimplesRouter extends HttpServlet {
    private static final long serialVersionUID = 13L;
    private static final Logger LOGGER = LoggerFactory.getLogger(SimplesRouter.class);
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final SessionDataService sessionDataService;
    private final IPAddressHandler ipAddressHandler;

    @SuppressWarnings("UnusedDeclaration")
    public SimplesRouter() {
        this(new SessionDataService(), IPAddressHandler.getInstance());
    }

    public SimplesRouter(SessionDataService sessionDataService, IPAddressHandler ipAddressHandler) {
        this.sessionDataService = sessionDataService;
        this.ipAddressHandler = ipAddressHandler;
        objectMapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uri = request.getRequestURI();
        PrintWriter writer = response.getWriter();

        // Automatically set content type based on request extension ////////////////////////////////////////

        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        }


        // Get common parameters ////////////////////////////////////////////////////////////////////////////

        Long transactionId = null;
        if (request.getParameter("transactionId") != null) {
            // throws NumberFormatException
            transactionId = Long.parseLong(request.getParameter("transactionId"));
        }

        AuthenticatedData authenticatedData;
        if (request.getSession() != null) {
            authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
        } else {
            response.sendError(SC_INTERNAL_SERVER_ERROR);
            return;
        }


        // Route the requests ///////////////////////////////////////////////////////////////////////////////

        if (uri.endsWith("/simples/comments/list.json")) {
            writer.print(TransactionService.getCommentsForTransactionId(RequestUtils.getTransactionIdFromRequest(request)));
        } else if (uri.endsWith("/simples/messages/next.json")) {
            getNextMessage(writer, request, response, authenticatedData);
        } else if (uri.endsWith("/simples/messages/get.json")) {
            getMessage(writer, request, response);
        } else if (uri.endsWith("/simples/messages/postponed.json")) {
            postponedMessages(writer, authenticatedData);
        } else if (uri.endsWith("/simples/tickle.json")) {
            doTickle(request, response, writer, transactionId, authenticatedData);
        } else if (uri.endsWith("/simples/transactions/lock.json")) {
            doLock(response, writer, transactionId, authenticatedData);
        } else if (uri.endsWith("/simples/transactions/unlock.json")) {
            doUnlock(response, writer, transactionId, authenticatedData);
        } else if (uri.endsWith("/simples/transactions/details.json")) {
            objectMapper.writeValue(writer, TransactionService.getMoreDetailsOfTransaction(RequestUtils.getTransactionIdFromRequest(request)));
        } else if (uri.endsWith("/simples/users/list_online.json")) {
            PageSettings settings = SettingsService.getPageSettingsByCode("CTM", VerticalType.SIMPLES.getCode());
            final SimplesUserService simplesUserService = new SimplesUserService();
            writer.print(simplesUserService.getUsersWhoAreLoggedIn(settings));
        } else if (uri.endsWith("/simples/users/stats_today.json")) {
            int simplesUid = authenticatedData.getSimplesUid();
            userStatsForToday(writer, simplesUid);
        } else if (uri.endsWith("/simples/phones/call.json")) {
            if (authenticatedData != null) {
                final String ext = authenticatedData.getExtension();
                final String phone = request.getParameter("phone");

                if (phone != null && !phone.isEmpty() && ext != null) {
                    if (makeCall(settings(), ext, phone)) {
                        response.setStatus(SC_OK);
                    } else {
                        response.sendError(SC_INTERNAL_SERVER_ERROR);
                    }
                } else {
                    response.sendError(SC_BAD_REQUEST);
                }
            }
        } else if (uri.endsWith("/general/phones/callInfo/get.json")) {
            if (authenticatedData != null) {
                final String ext = authenticatedData.getExtension();
                final String xpath = request.getParameter("xpath");

                if (xpath != null && !xpath.isEmpty() && ext != null) {
                    try {
                        objectMapper.writeValue(writer, CtiPhoneService.saveCallInfoForTransaction(settings(), ext, transactionId, xpath));
                    } catch (final ConfigSettingException e) {
                        LOGGER.error("Could not get callInfo {}, {}", kv("ext", ext), kv("xpath", xpath), e);
                        response.setStatus(SC_INTERNAL_SERVER_ERROR);
                        objectMapper.writeValue(writer, errors(e));
                    }
                } else {
                    objectMapper.writeValue(writer, jsonObjectNode("errors", singletonList(new Error("Could not get callInfo because missing either Xpath or Extension."))));
                }
            }
        } else if (uri.endsWith("/simples/admin/openinghours/getAllRecords.json")) {
            objectMapper.writeValue(writer, new OpeningHoursAdminService(ipAddressHandler).getAllHours(request));
        } else if (uri.endsWith("/simples/admin/offers/getAllRecords.json")) {
            objectMapper.writeValue(writer, new SpecialOffersService().getAllOffers());
        } else if (uri.endsWith("/simples/admin/helpbox/getAllRecords.json")) {
            objectMapper.writeValue(writer, new HelpBoxService().getAllHelpBox());
        } else if (uri.endsWith("/simples/admin/specialOptIn/getAllRecords.json")) {
            objectMapper.writeValue(writer, new SpecialOptInService().getAllSpecialOptIn());
        } else if (uri.contains("/simples/admin/")) {
            AdminRouter adminRouter = new AdminRouter(request, response, ipAddressHandler, objectMapper);
            adminRouter.doGet(uri.split("/simples/admin/")[1]);
        } else if (uri.contains("/simples/transaction/get.json")) {
            getTransaction(writer, request, response, authenticatedData);
        } else {
            response.sendError(SC_NOT_FOUND);
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uri = request.getRequestURI();
        PrintWriter writer = response.getWriter();
        AuthenticatedData authenticatedData;
        if (request.getSession() != null) {
            authenticatedData = sessionDataService.getAuthenticatedSessionData(request);
        } else {
            response.sendError(SC_INTERNAL_SERVER_ERROR);
            return;
        }

        if (uri.endsWith("/simples/admin/openinghours/update.json")) {
            OpeningHoursAdminService service = new OpeningHoursAdminService(ipAddressHandler);
            List<SchemaValidationError> errors = service.validateOpeningHoursData(request);
            if (errors == null || errors.isEmpty()) {
                objectMapper.writeValue(writer, service.updateOpeningHours(request, authenticatedData));
            } else {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", errors));
            }
        } else if (uri.endsWith("/simples/admin/openinghours/create.json")) {
            OpeningHoursAdminService service = new OpeningHoursAdminService(ipAddressHandler);
            List<SchemaValidationError> errors = service.validateOpeningHoursData(request);
            if (errors == null || errors.isEmpty()) {
                objectMapper.writeValue(writer, service.createOpeningHours(request, authenticatedData));
            } else {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", errors));
            }
        } else if (uri.endsWith("/simples/admin/openinghours/delete.json")) {
            String result = new OpeningHoursAdminService(ipAddressHandler).deleteOpeningHours(request, authenticatedData);
            if (!result.equalsIgnoreCase("success")) {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", result));
            } else {
                objectMapper.writeValue(writer, jsonObjectNode("result", result));
            }
        } else if (uri.endsWith("/simples/admin/offers/update.json")) {
            SpecialOffersService service = new SpecialOffersService();
            List<SchemaValidationError> errors = service.validateSpecialOffersData(request);
            if (errors == null || errors.isEmpty()) {
                objectMapper.writeValue(writer, service.updateSpecialOffers(request, authenticatedData));
            } else {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", errors));
            }
        } else if (uri.endsWith("/simples/admin/offers/create.json")) {
            SpecialOffersService service = new SpecialOffersService();
            List<SchemaValidationError> errors = service.validateSpecialOffersData(request);
            if (errors == null || errors.isEmpty()) {
                objectMapper.writeValue(writer, service.createSpecialOffers(request, authenticatedData));
            } else {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", errors));
            }
        } else if (uri.endsWith("/simples/admin/offers/delete.json")) {
            String result = new SpecialOffersService().deleteSpecialOffers(request, authenticatedData);
            if (!result.equalsIgnoreCase("success")) {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", result));
            } else {
                objectMapper.writeValue(writer, jsonObjectNode("result", result));
            }
        } else if (uri.endsWith("/simples/admin/helpbox/update.json")) {
            HelpBoxService service = new HelpBoxService();
            List<SchemaValidationError> errors = service.validateHelpBoxData(request, authenticatedData);
            if (errors == null || errors.isEmpty()) {
                try {
                    objectMapper.writeValue(writer, service.updateHelpBox(request, authenticatedData));
                } catch (CrudValidationException e) {
                    objectMapper.writeValue(writer, jsonObjectNode("error", e.getValidationErrors()));
                }
            } else {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", errors));
            }
        } else if (uri.endsWith("/simples/admin/helpbox/create.json")) {
            HelpBoxService service = new HelpBoxService();
            List<SchemaValidationError> errors = service.validateHelpBoxData(request, authenticatedData);
            if (errors == null || errors.isEmpty()) {
                try {
                    objectMapper.writeValue(writer, service.createHelpBox(request, authenticatedData));
                } catch (CrudValidationException e) {
                    objectMapper.writeValue(writer, jsonObjectNode("error", e.getValidationErrors()));
                }
            } else {
                response.setStatus(400);

            }
        } else if (uri.endsWith("/simples/admin/helpbox/delete.json")) {
            String result = new HelpBoxService().deleteHelpBox(request, authenticatedData);
            if (!result.equalsIgnoreCase("success")) {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", result));
            } else {
                objectMapper.writeValue(writer, jsonObjectNode("result", result));
            }
        } else if (uri.contains("/simples/admin/specialOptIn/update.json")) {
            SpecialOptInService service = new SpecialOptInService();
            List<SchemaValidationError> errors = service.validateSpecialOptInData(request, authenticatedData);
            if (errors == null || errors.isEmpty()) {
                try {
                    objectMapper.writeValue(writer, service.updateSpecialOptIn(request, authenticatedData));
                } catch (CrudValidationException e) {
                    objectMapper.writeValue(writer, jsonObjectNode("error", e.getValidationErrors()));
                }
            } else {
                response.setStatus(400);
                objectMapper.writeValue(writer, jsonObjectNode("error", errors));
            }
        } else if (uri.contains("/simples/admin/")) {
            AdminRouter adminRouter = new AdminRouter(request, response, ipAddressHandler, objectMapper);
            adminRouter.doPost(uri.split("/simples/admin/")[1]);
        } else {
            response.sendError(SC_NOT_FOUND);
        }


    }

    private void doTickle(HttpServletRequest request, HttpServletResponse response, PrintWriter writer, Long transactionId, AuthenticatedData authenticatedData) throws ServletException, IOException {
        setHeader(response);

        FatalErrorService fatalErrorService = new FatalErrorService();
        fatalErrorService.sessionId = request.getRequestedSessionId();

        try {
            SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.SIMPLES.getCode());
        } catch (DaoException | ConfigSettingException e) {
            fatalErrorService.logFatalError(e, 0, "simplesTickle", false, transactionId);
            LOGGER.error("Failed to set vertical and settings");
            throw new ServletException(e);
        }
        SimplesTickleService tickleService = new SimplesTickleService(sessionDataService);
        boolean success = tickleService.simplesTickle(request, transactionId, authenticatedData, new UserDao(), fatalErrorService);
        if (success) {
            objectMapper.writeValue(writer, jsonObjectNode("status", "OK"));
        } else {
            throw new ServletException("failed to perform tickle");
        }
    }

    private void doLock(HttpServletResponse response, PrintWriter writer, Long transactionId, AuthenticatedData authenticatedData) throws ServletException, IOException {
        setHeader(response);
        try {
            new AccessCheckService().createOrUpdateTransactionLock(transactionId, authenticatedData.getUid());
            objectMapper.writeValue(writer, jsonObjectNode("status", "OK"));
        } catch (DaoException e) {
            throw new ServletException("failed to perform lock");
        }
    }

    private void doUnlock(HttpServletResponse response, PrintWriter writer, Long transactionId, AuthenticatedData authenticatedData) throws ServletException, IOException {
        setHeader(response);
        try {
            new AccessCheckService().deleteTransactionLock(transactionId, authenticatedData.getUid());
            objectMapper.writeValue(writer, jsonObjectNode("status", "OK"));
        } catch (DaoException e) {
            throw new ServletException("failed to perform unlock");
        }
    }

    private void setHeader(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "-1");
    }

    private void postponedMessages(final PrintWriter writer, final AuthenticatedData authenticatedData) throws IOException {
        try {
            final int simplesUid = authenticatedData.getSimplesUid();
            final SimplesMessageService simplesMessageService = new SimplesMessageService(ipAddressHandler);
            final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", settings().getSetting("inInEnabled"));
            final List<Message> messages = inInEnabled ? simplesMessageService.scheduledCallbacks(simplesUid) : simplesMessageService.postponedMessages(simplesUid);
            objectMapper.writeValue(writer, jsonObjectNode("messages", messages));
        } catch (final DaoException | ConfigSettingException e) {
            objectMapper.writeValue(writer, errors(e));
        }
    }

    private void getMessage(final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response) throws IOException {
        try {
            final int messageId = parseInt(request.getParameter("messageId"));
            final SimplesMessageService simplesMessageService = new SimplesMessageService(ipAddressHandler);
            objectMapper.writeValue(writer, simplesMessageService.getMessage(messageId));
        } catch (final DaoException e) {
            response.setStatus(SC_INTERNAL_SERVER_ERROR);
            objectMapper.writeValue(writer, errors(e));
        } catch (final NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            objectMapper.writeValue(writer, errors(new Exception("messageId was not provided or is invalid.")));
        }
    }

    private void getNextMessage(final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response, final AuthenticatedData authenticatedData) throws IOException {
        int simplesUid = authenticatedData.getSimplesUid();
        try {
            SettingsService.setVerticalAndGetSettingsForPage(request, VerticalType.SIMPLES.getCode());

            final SimplesMessageService simplesMessageService = new SimplesMessageService(ipAddressHandler);
            objectMapper.writeValue(writer, simplesMessageService.getNextMessageForUser(request, simplesUid, authenticatedData.getGetNextMessageRules()));
        } catch (final DaoException | ConfigSettingException | ParseException e) {
            LOGGER.error("Could not get next simples message {}", kv("simplesUid", simplesUid), e);
            response.setStatus(SC_INTERNAL_SERVER_ERROR);
            objectMapper.writeValue(writer, errors(e));
        }
    }

    private void getTransaction(final PrintWriter writer, final HttpServletRequest request, final HttpServletResponse response, final AuthenticatedData authenticatedData) throws IOException {
        int simplesUid = authenticatedData.getSimplesUid();
        try {
            Optional<String> transactionId = Optional.ofNullable(request.getParameter("transactionId"));
            if (transactionId.map(StringUtils::isNotBlank).orElse(false) && transactionId.map(StringUtils::isNumeric).orElse(false)) {
                objectMapper.writeValue(writer, TransactionService.getTransaction(Long.parseLong(transactionId.get().trim())));
            }
        } catch (final DaoException e) {
            LOGGER.error("Could not get next simples message {}", kv("simplesUid", simplesUid), e);
            response.setStatus(SC_INTERNAL_SERVER_ERROR);
            objectMapper.writeValue(writer, errors(e));
        }
    }


    private void userStatsForToday(final PrintWriter writer, int userId) throws IOException {
        final SimplesUserService simplesUserService = new SimplesUserService();
        objectMapper.writeValue(writer, simplesUserService.getUserStatsForToday(userId));
    }

    private ObjectNode errors(final Exception e) {
        final Error error = new Error(e.getMessage());
        return jsonObjectNode("errors", singletonList(error));
    }

    private <T> ObjectNode jsonObjectNode(final String name, final T value) {
        final ObjectNode objectNode = objectMapper.createObjectNode();
        objectNode.putPOJO(name, value);
        return objectNode;
    }

    private PageSettings settings() {
        return SettingsService.getPageSettingsByCode("CTM", VerticalType.SIMPLES.getCode());
    }
}