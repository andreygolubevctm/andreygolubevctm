<%@ page language="java" contentType="application/json; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.fuel_price_results')}" />

<session:get settings="true" authenticated="true" verticalCode="FUEL"/>

<c:set var="continueOnValidationError" value="${true}"/>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="fuel" delete="false"/>

<%-- Capture the Client IP and User Agent used later to check limits--%>
<go:setData dataVar="data" xpath="fuel/clientIpAddress" value="${ipAddressHandler.getIPAddress(pageContext.request)}"/>
<go:setData dataVar="data" xpath="fuel/clientUserAgent" value='<%=request.getHeader("user-agent")%>' />
<c:set var="canSave" value="${data['fuel/canSave']}" />

<%-- R touch, plus save form data when we're told to --%>
<c:choose>
    <c:when test="${canSave eq '1'}">
        <core_v1:transaction touch="R" noResponse="true" />
    </c:when>
    <c:otherwise>
        <core_v1:transaction touch="R" noResponse="true" writeQuoteOverride="N" />
    </c:otherwise>
</c:choose>

<c:set var="tranId" value="${data['current/transactionId']}" />

<jsp:forward page="/spring/rest/fuel/quote/get.json"/>