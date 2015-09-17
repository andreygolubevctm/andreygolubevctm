<%@ page language="java" contentType="text/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}"/>

<session:get settings="true" authenticated="true" verticalCode="HEALTH" throwCheckAuthenticatedError="true"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="health"/>

<jsp:useBean id="applyServiceResponse" scope="request"
             type="com.ctm.providers.health.healthapply.model.response.HealthApplyResponse"/>

<c:set var="result" value="${applyServiceResponse.payload.quotes.get(0)}"/>

<jsp:useBean id="result" scope="request"
             type="com.ctm.providers.health.healthapply.model.response.HealthApplicationResponse"/>



<%-- Adjust the base rebate using multiplier - this is to ensure the rebate applicable to the
					commencement date is sent to the provider --%>


<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="app-response" value="*DELETE"/>
<%--<go:setData dataVar="data" xpath="app-response" xml="${resultXml}"/>--%>

<c:set var="errorMessage" value=""/>

<%-- Check for internal or provider errors and record the failed submission and add comments to the quote for call centre staff --%>
<c:if test="${result.errorList.size() > 0}">
    <c:forEach items="${result.errorList}" var="error" varStatus="pos">
        <c:if test="${not empty errorMessage}">
            <c:set var="errorMessage" value="${errorMessage}; "/>
        </c:if>
        <c:set var="errorMessage">${errorMessage}[${pos.count}]${error.message}</c:set>
    </c:forEach>

    <%-- Collate fund error messages, add fail touch and add quote comment --%>
    <c:if test="${not empty errorMessage}">
        <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
                               transactionId="${applyServiceResponse.transactionId}" productId="${result.productId}"/>
    </c:if>
</c:if>

<%-- Set transaction to confirmed if application was successful --%>
<c:choose>
    <c:when test="${result.success eq 'Success'}">
        <core:transaction touch="C" noResponse="true" productId="${result.productId}"/>

        <%--<c:set var="ignore">--%>
            <%--<jsp:useBean id="joinService" class="com.ctm.services.confirmation.JoinService"--%>
                         <%--scope="page"/>--%>
            <%--${joinService.writeJoin(tranId,productId)}--%>
        <%--</c:set>--%>


        <%--

        FIXME: Needs to be done in health apply service

        <c:set var="allowedErrors" value=""/>
        <c:catch var="writeAllowableErrorsException">
            &lt;%&ndash; Check any allowable errors and save to the database &ndash;%&gt;
            <c:set var="allowAbleErrorCount"
                   value="${results.allowedErrors.size()}"/>
            <c:if test="${allowAbleErrorCount > 0}">
                <c:forEach items="${results.allowedErrors}"
                           var="error" varStatus="pos">
                    <c:set var="allowedErrors">${allowedErrors}${error.code}</c:set>
                    <c:if test="${status.count < allowAbleErrorCount - 1}">
                        <c:set var="allowedErrors">${allowedErrors},</c:set>
                    </c:if>
                </c:forEach>
                <jsp:useBean id="healthTransactionDao"
                             class="com.ctm.dao.health.HealthTransactionDao" scope="page"/>
                ${healthTransactionDao.writeAllowableErrors(tranId , allowedErrors)}
            </c:if>
        </c:catch>
        <c:if test="${not empty writeAllowableErrorsException}">
            ${logger.warn('Exception thrown writing allowable errors. {}', log:kv('results', $results), writeAllowableErrorsException)}
            <error:non_fatal_error origin="health_application.jsp"
                                   errorMessage="failed to writeAllowableErrors tranId:${tranId} allowedErrors:${allowedErrors}"
                                   errorCode="DATABASE"/>
        </c:if>--%>

        <jsp:useBean id="serviceConfigurationService" class="com.ctm.services.ServiceConfigurationService" scope="session"/>


        <%-- Save confirmation record/snapshot --%>
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
        ${go:XMLtoJSON(resultXml)}
    </c:when>
    <%-- Was not successful --%>
    <%-- If no fail has been recorded yet --%>
    <x:otherwise>
        <c:choose>
            <%-- if online user record a join --%>
            <c:when test="${empty callCentre && empty errorMessage}">
                <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
                                       transactionId="${tranId}" productId="${productId}"/>
            </c:when>
            <%-- else just record a failure --%>
            <c:when test="${empty errorMessage}">
                <core:transaction touch="F" comment="Application success=false"
                                  noResponse="true" productId="${productId}"/>
                ${go:XMLtoJSON(resultXml)}
            </c:when>
        </c:choose>
    </x:otherwise>
</c:choose>
${logger.debug('Health application complete. {},{},{}', log:kv('transactionId',tranId), log:kv('resultXml', resultXml),log:kv( 'debugXml', debugXml))}
