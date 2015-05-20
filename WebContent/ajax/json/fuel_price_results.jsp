<%@ page language="java" contentType="text/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" authenticated="true" verticalCode="FUEL"/>

<c:set var="continueOnValidationError" value="${true}"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="fuel" delete="false"/>

<c:set var="fetch_count"><c:out value="${param.fetchcount}" escapeXml="true" /></c:set>

<c:choose>
    <%-- RECOVER: if things have gone pear shaped --%>
    <c:when test="${empty data.current.transactionId}">
        <error:recover origin="ajax/json/fuel_price_results.jsp" quoteType="fuel"/>
    </c:when>
    <%-- Increment tranId if fetching results again (not the first) --%>
    <c:when test="${fetch_count > 0}">
        <c:set var="ignoreme">
            <core:get_transaction_id
                    quoteType="fuel"
                    id_handler="increment_tranId"/>
        </c:set>
    </c:when>
    <%-- Otherwise ignore - no action required --%>
    <c:otherwise></c:otherwise>
</c:choose>

<%-- Check IP address to see if its permitted. --%>
<jsp:useBean id="ipCheckService" class="com.ctm.services.IPCheckService" />
<c:choose>
    <c:when test="${!ipCheckService.isPermittedAccess(pageContext.request, pageSettings)}">
        <go:setData dataVar="data" xpath="soap-response" value="*DELETE"/>
        <c:set var="resultXml">
            <results type="metro">
                <error>limit</error>
                <time>0</time>
                <result>
                    <siteid></siteid>
                    <name></name>
                    <fuelid></fuelid>
                </result>
            </results>
        </c:set>
        <go:setData dataVar="data" xpath="soap-response" xml="${resultXml}"/>
        ${go:XMLtoJSON(resultXml)}
    </c:when>
    <c:otherwise>
    <%-- Capture the Client IP and User Agent used later to check limits--%>
    <go:setData dataVar="data" xpath="fuel/clientIpAddress" value="${pageContext.request.remoteAddr}"/>
<go:setData dataVar="data" xpath="fuel/clientUserAgent" value="<%=request.getHeader("user-agent")%>" />

<%-- Save Client Data --%>
<core:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/fuel/config.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${go:getEscapedXml(data['fuel'])}"
					var = "resultXml"
					debugVar="debugXml"
					validationErrorsVar="validationErrors"
					continueOnValidationError="${continueOnValidationError}"
					isValidVar="isValid"
					verticalCode="FUEL"
					configDbKey="quoteService"
					styleCodeId="${pageSettings.getBrandId()}"
					 />

<c:choose>
	<c:when test="${isValid || continueOnValidationError}">
		<c:if test="${!isValid}">
			<c:forEach var="validationError"  items="${validationErrors}">
				<error:non_fatal_error origin="fuel_price_results.jsp"
									errorMessage="${validationError.message} ${validationError.elementXpath}" errorCode="VALIDATION" />
                </c:forEach>
            </c:if>
            <%-- Write to the stats database  --%>
            <agg:write_stats rootPath="fuel" tranId="${tranId}" debugXml="${debugXml}"/>

            <%-- Add the results to the current session data --%>
            <go:setData dataVar="data" xpath="soap-response" value="*DELETE"/>
            <go:setData dataVar="data" xpath="soap-response" xml="${resultXml}"/>
            <go:log level="DEBUG">${resultXml}</go:log>
            <go:log level="DEBUG">${debugXml}</go:log>

            ${go:XMLtoJSON(resultXml)}
        </c:when>
        <c:otherwise>
            <agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="fuel_price_results.jsp"/>
        </c:otherwise>
    </c:choose>
    </c:otherwise>
</c:choose>