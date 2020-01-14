<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.health_application_ws')}" />

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health"/>

<%-- Adjust the base rebate using multiplier - this is to ensure the rebate applicable to the
					commencement date is sent to the provider --%>
<c:set var="effectiveDate" value="${data.health.payment.details.start}"/>
<jsp:useBean id="changeOverRebatesService" class="com.ctm.web.simples.services.ChangeOverRebatesService" />
<c:set var="changeOverRebates" value="${changeOverRebatesService.getChangeOverRebate(effectiveDate)}"/>
<c:set var="rebate_multiplier_previous" value="${changeOverRebates.getPreviousMultiplier()}"/>
<c:set var="rebate_multiplier_current" value="${changeOverRebates.getCurrentMultiplier()}"/>
<c:set var="rebate_multiplier_future" value="${changeOverRebates.getFutureMultiplier()}"/>


<jsp:useBean id="healthApplicationService" class="com.ctm.web.health.services.HealthApplicationService" scope="page"/>
<c:set var="validationResponse"
       value="${healthApplicationService.setUpApplication(data, pageContext.request, changeOverRebates.getEffectiveStart())}"/>

<c:set var="tranId" value="${data.current.transactionId}"/>
<c:set var="productId" value="${fn:substringAfter(param.health_application_productId,'HEALTH-')}"/>
<c:set var="productCode" value="${param.health_application_productName}" />
<c:set var="continueOnAggregatorValidationError" value="${true}"/>

<jsp:useBean id="accessTouchService" class="com.ctm.web.core.services.AccessTouchService" scope="page"/>
<c:set var="touch_count">
    <core_v1:access_count touch="P"/>
</c:set>

<jsp:useBean id="healthLeadService" class="com.ctm.web.health.services.HealthLeadService" scope="request" />

<c:choose>
    <%--
	token can only be invalid for ONLINE.
	If invalid send the user to the pending page and let the call centre sort out
	TODO: move this over to HealthApplicationService
	--%>
    <c:when test="${!healthApplicationService.validToken}">
        <health_v1:set_to_pending errorMessage="Token is not valid." resultJson="${healthApplicationService.createTokenValidationFailedResponse(data.current.transactionId,pageContext.session.id)}"  transactionId="${resultXml}" productId="${productId}" productCode="${productCode}"/>
    </c:when>
    <%-- only output validation errors if call centre --%>
    <c:when test="${!healthApplicationService.valid && callCentre}">
        ${validationResponse}
    </c:when>
    <%-- set to pending if online and validation fails --%>
    <c:when test="${!healthApplicationService.valid && !callCentre}">
        <c:set var="resultXml"><result><success>false</success><errors></c:set>
        <c:forEach var="validationError" items="${healthApplicationService.getValidationErrors()}">
            <c:set var="resultXml">${resultXml}
                <error>
                    <code>${validationError.message}</code>
                    <original>${validationError.elementXpath}</original>
                </error>
            </c:set>
        </c:forEach>
        <c:set var="resultXml">${resultXml}</errors></result></c:set>
        <health_v1:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}" transactionId="${tranId}"
                                  productId="${productId}" productCode="${productCode}"/>
    </c:when>
    <%-- check the if ONLINE user submitted more than 5 times [HLT-1092] --%>
    <c:when test="${empty callCentre and not empty touch_count and touch_count > 5}">
        <c:set var="errorMessage" value="You have attempted to submit this join more than 5 times."/>
        <core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
        ${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "submission")}

        <c:if test="${not empty data['health/privacyoptin'] and data['health/privacyoptin'] eq 'Y'}">
            ${healthLeadService.sendLead(4, data, pageContext.getRequest(), 'PENDING')}
        </c:if>

    </c:when>
    <%-- check the latest touch, to make sure a join is not already actively in progress [HLT-1092] --%>
    <c:when test="${accessTouchService.isBeingSubmitted(tranId)}">
        <c:set var="errorMessage" value="Your application is still being submitted. Please wait."/>
        <core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
        ${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage,  "submission")}
    </c:when>
    <c:otherwise>

        <%-- Save client data; use outcome to know if this transaction is already confirmed --%>
        <c:set var="ct_outcome">
            <core_v1:transaction touch="P"/>
        </c:set>
        ${logger.info('Application has been set to pending. {}',  log:kv('productId', productId))}


        <c:choose>
            <c:when test="${ct_outcome == 'C'}">
                <c:set var="errorMessage" value="Quote has already been submitted and confirmed."/>
                <core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" />
                ${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "confirmed")}
            </c:when>

            <c:when test="${ct_outcome == 'V' or ct_outcome == 'I'}">
                <c:set var="errorMessage"
                       value="Important details are missing from your session. Your session may have expired."/>
                <core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" />

                ${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "transaction")}
            </c:when>

            <c:when test="${not empty ct_outcome}">
                <c:set var="errorMessage" value="Application submit error. Code=${ct_outcome}"/>
                <core_v1:transaction touch="F" comment="${errorMessage}" noResponse="true" />

                <c:if test="${not empty data['health/privacyoptin'] and data['health/privacyoptin'] eq 'Y'}">
                    ${healthLeadService.sendLead(4, data, pageContext.getRequest(), 'PENDING')}
                </c:if>

                ${healthApplicationService.createErrorResponse(data.current.transactionId, errorMessage, "")}
            </c:when>
            <c:otherwise>
                <jsp:forward page="/spring/rest/health/apply/get.json"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>