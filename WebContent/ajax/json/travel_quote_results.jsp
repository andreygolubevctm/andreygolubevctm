<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- Load the params into data --%>
<go:setData dataVar="data" xpath="travel" value="*DELETE" />
<go:setData dataVar="data" value="*PARAMS" />

<go:setData dataVar="data" xpath="travel/clientIpAddress" value="${pageContext.request.remoteAddr}" />
<go:setData dataVar="data" xpath="travel/clientUserAgent" value="${clientUserAgent}" />

<c:if test="${param.initialSort == 'false'}">
	<c:import var="getTransactionID" url="../json/get_transactionid.jsp?quoteType=travel&id_handler=increment_tranId" />
</c:if>

<agg:write_quote productType="TRAVEL" rootPath="travel"/>

<c:set var="marketing">
<c:choose>
		<c:when test="${data.travel.marketing eq 'Y'}">Y</c:when>
		<c:otherwise>N</c:otherwise>
</c:choose>
</c:set>

<agg:write_email
	brand="CTM"
	vertical="TRAVEL"
	source="QUOTE"
	emailAddress="${data.travel.email}"
	firstName="${data.travel.firstName}"
	lastName="${data.travel.surname}"
	items="marketing=${marketing}" />

<%-- add external testing ip address checking and loading correct config and send quotes --%>
<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />

<%--<c:set var="amexIpAddress" value="10.132.168.247" />--%>

<%-- for declans home ip address --%>
<c:set var="amexIpAddress" value="10.132.168.247" />

<c:set var="wldcIpAddress1" value="203.42.115.13" />
<c:set var="wldcIpAddress2" value="203.42.119.13" />
<c:set var="wldcIpAddress3" value="61.88.76.13" />

<c:set var="otisIpAddress1" value="203.42.115.13" />
<c:set var="otisIpAddress2" value="203.42.119.13" />
<c:set var="otisIpAddress3" value="61.88.76.13" />

<c:set var="easyIpAddress" value="49.177.87.252" />

<c:set var="onefowIpAddress" value="0:0:0:0:0:0:0:2" />
<c:set var="agisIpAddress" value="0:0:0:0:0:0:0:2" />



<c:set var="tranId" value="${data['current/transactionId']}" />
<go:setData dataVar="data" xpath="travel/transactionId" value="${tranId}" />

<c:import var="config" url="/WEB-INF/aggregator/travel/config.xml" />

<%-- Load the config and send quotes to the aggregator gadget --%>
<go:soapAggregator config = "${config}"
					transactionId = "${tranId}" 
					xml = "${data.xml['travel']}" 
					var = "resultXml"
					debugVar="debugXml" />
					
<%-- Write to the stats database --%>
<travel:write_stats tranId="${tranId}" debugXml="${debugXml}" />

<%-- Add the results to the current session data --%>
<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
<go:log>${resultXml}</go:log>

<go:log>${debugXml}</go:log>  
${go:XMLtoJSON(resultXml)}

