<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<jsp:useBean id="now" class="java.util.Date"/>

<%-- Variables --%>
<fmt:formatDate var="date" value="${now}" pattern="YYYY-MM-dd"/>

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="${sessionScope.userIP }" />
<c:set var="tranId" value="${data.current.transactionId}" />
<c:import var="config" url="/WEB-INF/aggregator/health_application/bup/config_log.xml" />

<%--
We will need to complete the xml data here for sending through
--%>
<c:set var="xmlData"><request>
	<transactionId>${tranId}</transactionId>
	<ipAddress>${clientIpAddress}</ipAddress>
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
			debugVar="debugXml" />

${go:XMLtoJSON(resultXml)}