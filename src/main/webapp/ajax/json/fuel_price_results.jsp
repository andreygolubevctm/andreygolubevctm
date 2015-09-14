<%@ page language="java" contentType="text/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<session:get settings="true" authenticated="true" verticalCode="FUEL"/>

<%-- Check IP address to see if its permitted. --%>
<jsp:useBean id="ipCheckService" class="com.ctm.services.IPCheckService" />
<c:choose>
    <%-- Check and increment counter for IP address --%>
    <c:when test="${!ipCheckService.isPermittedAccess(pageContext.request, pageSettings)}">
        <%-- Throw 429 error so that F5 will detect scrape and frontend will
             check response and display applicable error --%>
        <%	response.sendError(429, "Number of requests exceeded!" ); %>
    </c:when>
    <c:when test="${empty data.current.transactionId}">
        <%-- If no transaction ID then don't attempt to recover the session - just
             return a canned response --%>
        <c:set var="resultXml">
            <results>
                <source>metro</source>
                <error>session</error>
                <timeDiff>0</timeDiff>
                <price></price>
            </results>
        </c:set>

        <%-- Add the results to the current session data --%>
        <go:setData dataVar="data" xpath="soap-response" value="*DELETE"/>
        <go:setData dataVar="data" xpath="soap-response" xml="${resultXml}"/>
        ${logger.debug('Invalid transaction id returning called response. {}', log:kv('resultXml',resultXml))}
        ${go:XMLtoJSON(resultXml)}
    </c:when>
    <c:otherwise>

        <c:set var="continueOnValidationError" value="${true}"/>

        <%-- Load the params into data --%>
        <security:populateDataFromParams rootPath="fuel" delete="false"/>

        <c:set var="fetch_count"><c:out value="${param.fetchcount}" escapeXml="true" /></c:set>

        <c:if test="${fetch_count > 0}">
            <c:set var="ignoreme">
                <core:get_transaction_id
                        quoteType="fuel"
                        id_handler="increment_tranId"/>
            </c:set>
        </c:if>

        <%-- Capture the Client IP and User Agent used later to check limits--%>
        <go:setData dataVar="data" xpath="fuel/clientIpAddress" value="${pageContext.request.remoteAddr}"/>
        <go:setData dataVar="data" xpath="fuel/clientUserAgent" value='<%=request.getHeader("user-agent")%>' />

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
                ${go:XMLtoJSON(resultXml)}
            </c:when>
            <c:otherwise>
                <agg:outputValidationFailureJSON validationErrors="${validationErrors}" origin="fuel_price_results.jsp"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>