<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="ip" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="ip" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />
		
		<go:setData dataVar="data" xpath="ip/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="ip/clientUserAgent" value="${clientUserAgent}" />

		<%-- Save client data --%>
		<agg:write_quote productType="IP" rootPath="ip"/>
		
		<%-- add external testing ip address checking and loading correct config and send quotes --%>
		<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />
		
		<c:set var="tranId" value="${data.current.transactionId}" />
		<go:setData dataVar="data" xpath="ip/transactionId" value="${tranId}" />
		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/ip/config_results.xml" />
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}" 
							xml = "${data.xml['ip']}" 
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
		
		<c:choose>
			<c:when test="${not empty param.ignoretouch}"><%-- NO TOUCH REQUIRED --%></c:when>
			<c:otherwise>
				<c:set var="ignore_me"><core:access_touch quoteType="ip" type="R" transaction_id="${data.current.transactionId}" /></c:set>
			</c:otherwise>
		</c:choose>
		
		<go:log>${resultXml}</go:log>
		<go:log>${debugXml}</go:log>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error>
		</c:set>		
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(resultXml)}