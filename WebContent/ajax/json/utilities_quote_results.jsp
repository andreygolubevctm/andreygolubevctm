<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<security:populateDataFromParams rootPath="utilities" />


<%-- RECOVER: if things have gone pear shaped --%>
<c:if test="${empty data.current.transactionId}">
	<error:recover origin="ajax/json/utilities_quote_results.jsp" quoteType="utilities" />
</c:if>

<%-- Save client data --%>
<core:transaction touch="R" noResponse="true" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />

<go:log>Utilities Tran Id = ${data['current/transactionId']}</go:log>

<c:set var="tranId" value="${data['current/transactionId']}" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/aggregator/utilities/config_results.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${data.xml['utilities']}"
					var = "resultXml"
					debugVar="debugXml" />

<%-- Write to the stats database --%>
<utilities:write_stats tranId="${tranId}" debugXml="${debugXml}" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

<go:log>RESULTS XML: ${resultXml}</go:log>
<go:log>DEBUG XML: ${debugXml}</go:log>

${go:XMLtoJSON(resultXml)}