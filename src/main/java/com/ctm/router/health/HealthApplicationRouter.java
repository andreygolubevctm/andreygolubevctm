package com.ctm.router.health;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.ServiceConfigurationException;
import com.ctm.model.Confirmation;
import com.ctm.model.Touch;
import com.ctm.model.health.form.HealthRequest;
import com.ctm.model.settings.Brand;
import com.ctm.model.settings.Vertical;
import com.ctm.providers.health.healthapply.model.response.HealthApplicationResponse;
import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;
import com.ctm.providers.health.healthapply.model.response.Status;
import com.ctm.router.CommonQuoteRouter;
import com.ctm.services.TouchService;
import com.ctm.services.TransactionAccessService;
import com.ctm.services.confirmation.ConfirmationService;
import com.ctm.services.confirmation.JoinService;
import com.ctm.services.health.HealthApplyService;
import com.ctm.services.simples.ProviderContentService;
import com.ctm.utils.ObjectMapperUtil;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import static com.ctm.logging.LoggingArguments.kv;
import static com.ctm.model.settings.Vertical.VerticalType.HEALTH;

@Path("/health")
public class HealthApplicationRouter extends CommonQuoteRouter<HealthRequest> {

    private static final Logger LOGGER = LoggerFactory.getLogger(HealthApplicationRouter.class);

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    private final HealthApplyService healthApplyService = new HealthApplyService();

    private final JoinService joinService = new JoinService();

    private final ProviderContentService providerContentService = new ProviderContentService();

    private final TransactionAccessService transactionAccessService = new TransactionAccessService();

    private final ConfirmationService confirmationService = new ConfirmationService();

    @POST
    @Path("/apply/get.json")
    @Consumes({"multipart/form-data", "application/x-www-form-urlencoded"})
    @Produces("text/html")
    public HealthApplyResponse getHealthApply(@Context MessageContext context, @FormParam("") final HealthRequest data) throws DaoException, IOException, ServiceConfigurationException, ConfigSettingException {

        Vertical.VerticalType vertical = HEALTH;

        // Initialise request
        Brand brand = initRouter(context, vertical);
        updateTransactionIdAndClientIP(context, data); // TODO check IP Address is correct

        final HealthApplyResponse applyResponse = healthApplyService.apply(brand, data);

        final String confirmationId = context.getHttpServletRequest().getSession().getId() + "-" + data.getTransactionId();

        final HealthApplicationResponse response = applyResponse.getPayload().getQuotes().get(0);

        final String productId = data.getQuote().getApplication().getProductId()
                .substring(data.getQuote().getApplication().getProductId().indexOf("HEALTH-") + 7);

        // Collate the error list messages
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < response.getErrorList().size(); i++) {
            // Expects 1 base position value
            sb.append("[").append(i+1).append("]").append(response.getErrorList().get(i).getMessage());
        }

        // Record touch of the error list messages
        final String errorMessage = sb.toString();
        if (!errorMessage.isEmpty()) {
            Touch touch = new Touch();
            touch.setType(Touch.TouchType.FAIL);
            touch.setTransactionId(data.getTransactionId());
            TouchService.getInstance().recordTouchWithProductId(context.getHttpServletRequest(), touch, productId);
            // TODO: Add comments
            // TODO: Add pendingId
            // TODO: add fatalerrorreason
        }

        if (Status.Success.equals(response.getSuccess())) {
            applyResponse.setSuccess(true);
            // Record Confirmation touch
            Touch touch = new Touch();
            touch.setType(Touch.TouchType.SOLD);
            touch.setTransactionId(data.getTransactionId());
            TouchService.getInstance().recordTouchWithProductId(context.getHttpServletRequest(), touch, productId);

            // Write to the join table
            joinService.writeJoin(data.getTransactionId(), productId);

            try {
                transactionAccessService.addTransactionDetail(data.getTransactionId(), -2, "health/policyNo", response.getProductId());
            } catch (Exception e) {
                LOGGER.warn("Failed to add transactionDetail {} because {}", data.getTransactionId(), e);
            }

            applyResponse.setCallcentre((Boolean)context.getHttpServletRequest().getSession().getAttribute("callCentre"));

            final ConfirmationData confirmationData = new ConfirmationData(data.getTransactionId().toString(),
                    LocalDate.parse(data.getQuote().getPayment().getDetails().getStart(), AUS_FORMAT),
                    data.getQuote().getPayment().getDetails().getFrequency(),
                    providerContentService.getProviderContentText(context.getHttpServletRequest(), data.getHealth().getApplication().getProviderName(), "ABT"),
                    providerContentService.getProviderContentText(context.getHttpServletRequest(), data.getHealth().getApplication().getProviderName(), "NXT"),
                    data.getQuote().getApplication().getProductId(),
                    response.getProductId());

            Confirmation confirmation = new Confirmation();
            confirmation.setKey(confirmationId);
            confirmation.setTransactionId(data.getTransactionId());
            confirmation.setXmlData(ObjectMapperUtil.getXmlMapper().writeValueAsString(confirmationData));

            boolean confirmed = false;

            try {
                confirmed = confirmationService.addConfirmation(confirmation);
                applyResponse.setConfirmationID(confirmationId);
                applyResponse.setEmail(data.getQuote().getApplication().getEmail());
                // TODO: set the bccEmail from provider
//                applyResponse.setBccEmail();
            } catch (Exception e) {
                LOGGER.warn("Failed to add confirmation {} because {}", confirmationId, e);

            }

            // TODO: add competition entry

            // Check outcome was ok --%>
            LOGGER.info("Transaction has been set to confirmed. {},{}", kv("transactionId" , data.getTransactionId()), kv("confirmationID", confirmationId));

//```````````
        /*<%-- Save confirmation record/snapshot --%>
        <%--<c:import var="saveConfirmation" url="/ajax/write/save_health_confirmation.jsp">
        <c:param name="policyNo" value="${result.productId}"/>
        <c:param name="startDate" value="${data['health/payment/details/start']}"/>
        <c:param name="frequency" value="${data['health/payment/details/frequency']}"/>
        <c:param name="bccEmail" value="${serviceConfigurationService.getServiceConfiguration('')}"/>
        </c:import>--%>

        <%-- Check outcome was ok --%>
        <x:parse doc="${saveConfirmation}" var="saveConfirmationXml"/>
        <x:choose>
            <x:when select="$saveConfirmationXml/response/status = 'OK'">
                <c:set var="confirmationID">
                    <x:out select="$saveConfirmationXml/response/confirmationID"/>
                </c:set>
            </x:when>
            <x:otherwise></x:otherwise>
        </x:choose>
        ${logger.info('Transaction has been set to confirmed. {},{}', log:kv('transactionId' , tranId), log:kv('confirmationID',confirmationID ))}
        <c:set var="confirmationID">
            <confirmationID>
                <c:out value="${confirmationID}"/>
            </confirmationID>
            </result>
        </c:set>
        <c:set var="resultXml" value="${fn:replace(resultXml, '</result>', confirmationID)}"/>
        ${go:XMLtoJSON(resultXml)}*/


        } else {
            applyResponse.setSuccess(false);
            applyResponse.setPendingID(confirmationId);
            /*<c:when test="${empty callCentre && empty errorMessage}">
            <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
            transactionId="${tranId}" productId="${productId}"/>
            </c:when>*/
        }

        LOGGER.debug("Health application complete. {},{}", kv("transactionId", data.getTransactionId()), kv("response", applyResponse));


        return applyResponse;
    }

}
