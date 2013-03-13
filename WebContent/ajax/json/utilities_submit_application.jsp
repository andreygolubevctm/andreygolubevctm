<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="utilities" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="utilities/clientIpAddress" value="${pageContext.request.remoteAddr}" />

<%-- Save client data --%>
<agg:write_quote productType="UTILITIES" rootPath="utilities"/>

<c:set var="receiveInfo">
	<c:choose>
		<c:when test="${empty data['utilities/application/thingsToKnow/receiveInfo']}">N</c:when>
		<c:otherwise>${data['utilities/application/thingsToKnow/receiveInfo']}</c:otherwise>
	</c:choose>
</c:set>
<agg:write_email
	emailSource="UTIL"
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