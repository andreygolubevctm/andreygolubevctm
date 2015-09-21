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

<jsp:useBean id="result" scope="page"
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

        <%-- Save confirmation record/snapshot --%>
        <%--<c:import var="saveConfirmation" url="/ajax/write/save_health_confirmation.jsp">
            <c:param name="policyNo" value="${result.productId}"/>
            <c:param name="startDate" value="${data['health/payment/details/start']}"/>
            <c:param name="frequency" value="${data['health/payment/details/frequency']}"/>
            <c:param name="bccEmail" value="${serviceConfigurationService.getServiceConfiguration('')}"/>
        </c:import>--%>

        <c:set var="emailResponse">
            <c:import url="/ajax/json/send.jsp">
                <c:param name="vertical" value="HEALTH" />
                <c:param name="mode" value="app" />
                <c:param name="emailAddress" value="${applyServiceResponse.email}" />
                <c:param name="bccEmail" value="${applyServiceResponse.bccEmail}" />
            </c:import>
        </c:set>

        <%-- Store the emailResponse's ID against the transaction to know it was emailed --%>
        <%-- emailResponseXML is created as a session variable inside send.jsp and send.jsp under dreammail (one imports the other) --%>
        <c:catch var="storeEmailResponse">
            <c:if test="${not empty emailResponseXML}">

                <x:parse xml="${emailResponseXML}" var="confirmationXML" />

                <%-- //FIX: handle the error and force it into the --%>
                <c:set var="confirmationCode">
                    <x:choose>
                        <%-- For ExactTarget style responses: --%>
                        <x:when select="$confirmationXML//*[local-name()='Body']/*[name()='CreateResponse']/*[name()='RequestID']"><x:out select="$confirmationXML//*[local-name()='Body']/*[name()='CreateResponse']/*[name()='RequestID']" /></x:when>
                        <%-- For old (Permission???) based responses: --%>
                        <%--
                        <x:when select="$confirmationXML/DMResponse/ResultData/TransactionID"><x:out select="$confirmationXML/DMResponse/ResultData/TransactionID" /></x:when>
                        --%>
                        <x:otherwise>0</x:otherwise>
                    </x:choose>
                </c:set>

                <sql:setDataSource dataSource="jdbc/ctm"/>
                <sql:update>
                    INSERT INTO aggregator.transaction_details
                    (transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
                    values (?, ?, ?, ?,	default, now());
                    <sql:param value="${applyServiceResponse.transactionId}" />
                    <sql:param value="${-1}" />
                    <sql:param value="health/confirmationEmailCode" />
                    <sql:param value="${confirmationCode}" />
                </sql:update>
            </c:if>
        </c:catch>
        <c:choose>
            <c:when test="${empty storeEmailResponse}">
                ${logger.info('Updated transaction details with record of email provider\'s confirmation code. {}', log:kv('confirmationCode',confirmationCode ))}
            </c:when>
            <c:otherwise>
                ${logger.info('Failed to Update transaction details with record of confirmation code. {}', log:kv('storeEmailResponse',storeEmailResponse ))}
            </c:otherwise>
        </c:choose>

        <c:set var="resultXml"><result responseTime="10"><success>true</success><confirmationID>${applyServiceResponse.confirmationID}</confirmationID></result></c:set>

        ${go:XMLtoJSON(resultXml)}

    </c:when>
    <%-- Was not successful --%>
    <%-- If no fail has been recorded yet --%>
    <c:otherwise>
        <c:choose>
            <%-- if online user record a join --%>
            <c:when test="${empty callCentre && empty errorMessage}">
                <health:set_to_pending errorMessage="${errorMessage}" resultXml="${resultXml}"
                                       transactionId="${applyServiceResponse.transactionId}" productId="${result.productId}"/>
            </c:when>
            <%-- else just record a failure --%>
            <c:when test="${empty errorMessage}">
                <core:transaction touch="F" comment="Application success=false"
                                  noResponse="true" productId="${productId}"/>
                ${go:XMLtoJSON(resultXml)}
            </c:when>
        </c:choose>
    </c:otherwise>
</c:choose>

