<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="utilities" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="utilities/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="utilities/clientUserAgent" value="${clientUserAgent}" />

<%-- Save client data --%>
<agg:write_quote productType="UTILITIES" rootPath="utilities"/>

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
