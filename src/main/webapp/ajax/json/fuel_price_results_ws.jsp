<%@ page language="java" contentType="application/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.fuel_price_results')}" />

<session:get settings="true" authenticated="true" verticalCode="FUEL"/>

<c:set var="continueOnValidationError" value="${true}"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="fuel" delete="false"/>

<c:set var="fetch_count"><c:out value="${param.fetchcount}" escapeXml="true" /></c:set>

<c:if test="${fetch_count > 0}">
    <c:set var="ignoreme">
        <core_v1:get_transaction_id
                quoteType="fuel"
                id_handler="increment_tranId"/>
    </c:set>
</c:if>

<%-- Capture the Client IP and User Agent used later to check limits--%>
<go:setData dataVar="data" xpath="fuel/clientIpAddress" value="${ipAddressHandler.getIPAddress(pageContext.request)}"/>
<go:setData dataVar="data" xpath="fuel/clientUserAgent" value='<%=request.getHeader("user-agent")%>' />

<%-- Save Client Data --%>
<core_v1:transaction touch="R" noResponse="true" />

<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:forward page="/spring/rest/fuel/quote/get.json"/>