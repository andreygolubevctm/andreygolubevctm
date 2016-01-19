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
<jsp:useBean id="configResolver" class="com.ctm.web.core.utils.ConfigResolver" scope="application" />
<c:set var="config" value="${configResolver.getConfig(pageContext.request.servletContext, '/WEB-INF/aggregator/health_application/bup/config_token.xml')}" />

<%--
	There are issues with this working the first time due to security constraints
	This can only be run once otherwise it will cause a duplicate request bug (even if it fails).
--%>

<%-- Create a URL set, and remove the trailing slash which IPP adds --%>
<c:set var="dynamicUrl" value="<dynamicUrl>${pageSettings.getBaseUrl()}</dynamicUrl>" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
			transactionId = "${tranId}"
			configDbKey="ippService"
			verticalCode="${verticalCode}"
			styleCodeId="${pageSettings.getBrandId()}"
			xml = "<request>${fn:replace(dynamicUrl, '/</','</')}<transactionId>${tranId}</transactionId><env>${environmentService.getEnvironmentAsString()}</env><ipAddress>${clientIpAddress}</ipAddress></request>"
			var = "resultXml"
			debugVar="debugXml" />

${go:XMLtoJSON(resultXml)}