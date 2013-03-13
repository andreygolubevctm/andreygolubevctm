<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="health" /></c:set>
<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>
		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="health" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />

		<go:setData dataVar="data" xpath="health/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="health/clientUserAgent" value="${clientUserAgent}" />
		
		<c:if test="${not empty param.increment_tranId}">
			<c:import var="getTransactionID" url="../json/get_transactionid.jsp?id_handler=increment_tranId" />
		</c:if>

		<%-- Save client data --%>
		<agg:write_quote productType="HEALTH" rootPath="health"/>

		<%-- add external testing ip address checking and loading correct config and send quotes --%>
		<c:set var="clientIp" value="<%=request.getRemoteAddr()%>" />

		<c:set var="tranId" value="${data.current.transactionId}" />

		<c:set var="gmf" value="203.153.239.89" />
		<c:set var="hcf" value="202.68.174.227" />
		<c:set var="nib" value="127.0.0.1" />
		<c:set var="gmh" value="127.0.0.1" />
		<c:set var="auf" value="127.0.0.1" />
		<c:set var="wfd" value="127.0.0.1" />


		<c:set var="teresa" value="192.168.11.36" />
		<c:set var="alex" value="192.168.12.132" />
		<c:set var="alexx" value="127.0.0.1" />
		<c:set var="teresax" value="127.0.0.1" />

		<c:set var="configName">
			<c:choose>
				<c:when test="${clientIp == gmf or clientIp==alex}">GMF</c:when>
				<c:when test="${clientIp == hcf or clientIp==alex}">HCF</c:when>
				<c:when test="${clientIp == nib or clientIp==alex}">NIB</c:when>	
				<c:when test="${clientIp == gmh or clientIp==alex}">GMH</c:when>	
				<c:when test="${clientIp == auf or clientIp==alex}">AUF</c:when>	
				<c:when test="${clientIp == wfd or clientIp==alex}">WFD</c:when>	
				<c:when test="${fn:startsWith(clientIp,'192.168.')}">ALL</c:when>
				<c:otherwise>ALL</c:otherwise>
			</c:choose>
		</c:set>
		<go:log>IP=${clientIp} Config=${configName}</go:log>
		<c:import var="config" url="/WEB-INF/aggregator/health/config_${configName}.xml" />


		<%-- Load the config and send quotes to the aggregator gadget --%>
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}" 
							xml = "${data.xml['health']}" 
							var = "resultXml"
							debugVar="debugXml" />
							
		<%-- //FIX: turn this back on when you are ready!!!! 
		<%-- Write to the stats database 
		<agg:write_stats tranId="${tranId}" debugXml="${debugXml}" />
		--%>

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

		<c:set var="ignore_me"><core:access_touch quoteType="health" type="R" transaction_id="${data.current.transactionId}" /></c:set>
		
		<%--
		<go:log>${resultXml}</go:log>
		<go:log>${debugXml}</go:log>
		--%>
	</c:when>
	<c:otherwise>
		<c:set var="resultXml">
			<error><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></error>
		</c:set>
	</c:otherwise>
</c:choose>
${go:XMLtoJSON(resultXml)}
