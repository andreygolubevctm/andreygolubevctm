<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="utilities" />


<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/utilities_submit_application.jsp" quoteType="utilities" />
</c:if>

<%-- Save client data: ***FIX: before using this a 'C' status needs to be identified.
<core:transaction touch="A" noResponse="true" />
--%>
<core:transaction touch="P" noResponse="true" />

<c:set var="receiveInfo">
	<c:choose>
		<c:when test="${empty data['utilities/application/thingsToKnow/receiveInfo']}">N</c:when>
		<c:otherwise>${data['utilities/application/thingsToKnow/receiveInfo']}</c:otherwise>
	</c:choose>
</c:set>

<agg:write_email
	brand="CTM"
	vertical="UTILITIES"
	source="QUOTE"
	emailAddress="${data['utilities/application/details/email']}"
	firstName="${data['utilities/application/details/firstName']}"
	lastName="${data['utilities/application/details/lastName']}"
	items="marketing=${receiveInfo}" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />

<go:log>Utilities Tran Id = ${data['current/transactionId']}</go:log>
<c:set var="tranId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/utilities/config_application.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${data.xml['utilities']}"
					var = "resultXml"
					debugVar="debugXml" />

<%-- //FIX: turn this back on when you are ready!!!!
<%-- Write to the stats database
<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />
--%>

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

<go:log>RESULTS XML: ${resultXml}</go:log>
<go:log>DEBUG XML: ${debugXml}</go:log>

${go:XMLtoJSON(resultXml)}