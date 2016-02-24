<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<c:set var="verticalCode" value="HEALTH" />
<session:get settings="true" verticalCode="${verticalCode}" />


<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="${pageContext.request.remoteAddr}" />
<c:set var="tranId">
    <c:choose>
        <c:when test="${not empty data.current.transactionId}">
            ${data.current.transactionId}
        </c:when>
        <c:otherwise>
            <c:out escapeXml="true" value="${param.transactionId}" />
        </c:otherwise>
    </c:choose>
</c:set>

<jsp:useBean id="now" class="java.util.Date"/>

<%-- Variables --%>
<fmt:formatDate var="date" value="${now}" pattern="YYYY-MM-dd"/>
<c:set var="tranId" value="${data.current.transactionId}" />
<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/health_application/bup/config_log.xml')}" />

<%--
We will need to complete the xml data here for sending through
--%>
<c:set var="xmlData"><request>
	<transactionId>${tranId}</transactionId>
	<ipAddress>${pageContext.request.remoteAddr}</ipAddress>
	<sst><c:out value="${param.sst}" escapeXml="true" /></sst>
	<cardType><c:out value="${param.cardtype}" escapeXml="true" /></cardType>
	<token><c:out value="${param.token}" escapeXml="true" /></token>
	<maskedNumber><c:out value="${param.maskedcardno}" escapeXml="true" /></maskedNumber>
	<responseCode><c:out value="${param.responsecode}" escapeXml="true" /></responseCode>
	<responseResult><c:out value="${param.responseresult}" escapeXml="true" /></responseResult>
	<sessionId><c:out value="${param.sessionid}" escapeXml="true" /></sessionId>
	<date>${date}</date>
</request></c:set>

<go:soapAggregator config = "${config}"
			transactionId = "${tranId}"
			xml = "${xmlData}"
			var = "resultXml"
			debugVar="debugXml"
			configDbKey="ippService"
			verticalCode="${verticalCode}"
			styleCodeId="${pageSettings.getBrandId()}" />

${go:XMLtoJSON(resultXml)}