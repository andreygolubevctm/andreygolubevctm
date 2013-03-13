<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="*" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

					
<%-- Write to the stats database --%>
<%--<travel:write_stats tranId="${tranId}" debugXml="${debugXml}" />--%>

<c:import var="config" url="/WEB-INF/aggregator/travel/config.xml" />


<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}" 
					xml = "${data.xml['travel']}" 
					var = "resultXml"
					debugVar="debugXml" />
					
<%-- Write to the stats database --%>
<%--<travel:write_stats tranId="${tranId}" debugXml="${debugXml}" />--%>

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:log>${resultXml}</go:log>

<go:log>${debugXml}</go:log>  
${go:XMLtoJSON(resultXml)}

