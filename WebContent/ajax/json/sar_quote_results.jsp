<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="roadside" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="roadside/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="roadside/clientUserAgent" value="${clientUserAgent}" />

<%-- Save client data --%>
<agg:write_client productType="ROADSIDE" rootPath="roadside" />


<c:set var="tranId" value="${data['roadside/transactionId']}" />


<%-- Load the config and send quotes to the aggregator gadget --%>
<c:import var="config" url="/WEB-INF/classes/aggregator/roadside/config.xml" />
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}"
					xml = "${data.xml['roadside']}"
					var = "resultXml"
					debugVar="debugXml" />


<%-- Write to the stats database --%>
<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:log>${resultXml}</go:log>
<go:log>${debugXml}</go:log>

${go:XMLtoJSON(resultXml)}