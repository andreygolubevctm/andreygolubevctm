<%@ page language="java" contentType="text/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}"/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health"/>

<%-- Adjust the base rebate using multiplier - this is to ensure the rebate applicable to the
					commencement date is sent to the provider --%>
<health:changeover_rebates effective_date="${data.health.payment.details.start}"/>
<jsp:useBean id="healthApplicationService" class="com.ctm.services.health.HealthApplicationService" scope="page"/>
<c:set var="validationResponse"
       value="${healthApplicationService.setUpApplication(data, pageContext.request, changeover_date_2)}"/>

<c:set var="tranId" value="${data.current.transactionId}"/>
<c:set var="productId" value="${fn:substringAfter(param.health_application_productId,'HEALTH-')}"/>
<c:set var="continueOnAggregatorValidationError" value="${true}"/>

<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="page"/>
<c:set var="touch_count">
    <core:access_count touch="P"/>
</c:set>

<c:choose>
    <%-- only output validation errors if call centre --%>
    <c:when test="${!healthApplicationService.isValid() && callCentre}">
        ${validationResponse}
    </c:when>
    <%-- set to pending if online and validation fails --%>
    <c:when test="${!healthApplicationService.isValid() && !callCentre}">
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
        <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}" transactionId="${tranId}"
                               productId="${productId}"/>
    </c:when>
    <%-- check the if ONLINE user submitted more than 5 times [HLT-1092] --%>
    <c:when test="${empty callCentre and not empty touch_count and touch_count > 5}">
        <c:set var="errorMessage" value="You have attempted to submit this join more than 5 times."/>
        <core:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
        { "error": { "type":"submission", "message":"${errorMessage}" } }
    </c:when>
    <%-- check the latest touch, to make sure a join is not already actively in progress [HLT-1092] --%>
    <c:when test="${accessTouchService.isBeingSubmitted(tranId)}">
        <c:set var="errorMessage" value="Your application is still being submitted. Please wait."/>
        <core:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
        { "error": { "type":"submission", "message":"${errorMessage}" } }
    </c:when>
    <c:otherwise>
        <%-- Save client data; use outcome to know if this transaction is already confirmed --%>
        <c:set var="ct_outcome">
            <core:transaction touch="P"/>
        </c:set>
        ${logger.info('Application has been set to pending. {},{}', log:kv('transactionId', tranId), log:kv('productId', productId))}

        <c:choose>
            <c:when test="${ct_outcome == 'C'}">
                <c:set var="errorMessage" value="Quote has already been submitted and confirmed."/>
                <core:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
                { "error": { "type":"confirmed", "message":"${errorMessage}" } }
            </c:when>

            <c:when test="${ct_outcome == 'V' or ct_outcome == 'I'}">
                <c:set var="errorMessage"
                       value="Important details are missing from your session. Your session may have expired."/>
                <core:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
                { "error": { "type":"transaction", "message":"${errorMessage}" } }
            </c:when>

            <c:when test="${not empty ct_outcome}">
                <c:set var="errorMessage" value="Application submit error. Code=${ct_outcome}"/>
                <core:transaction touch="F" comment="${errorMessage}" noResponse="true" productId="${productId}"/>
                { "error": { "type":"", "message":"${errorMessage}" } }
            </c:when>

        </c:choose>
    </c:otherwise>
</c:choose>

<jsp:forward page="/rest/health/apply/get.json"/>