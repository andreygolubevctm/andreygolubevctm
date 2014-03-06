<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="${sessionScope.userIP }" />
<c:set var="tranId" value="${data.current.transactionId}" />
<c:import var="config" url="/WEB-INF/aggregator/health_application/bup/config_token.xml" />

<%--
	There are issues with this working the first time due to security constraints
	This can only be run once otherwise it will cause a duplicate request bug (even if it fails).
--%>

<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
			transactionId = "${tranId}"
			xml = "<request><transactionId>${tranId}</transactionId><env>${data.settings['environment']}</env><ipAddress>${clientIpAddress}</ipAddress></request>"
			var = "resultXml"
			debugVar="debugXml" />

${go:XMLtoJSON(resultXml)}