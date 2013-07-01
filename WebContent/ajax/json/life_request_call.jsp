<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="life" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="life" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />
		
		<go:setData dataVar="data" xpath="life/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="life/current/transactionId" value="${data.current.transactionId}" />

		<%-- Save client data --%>
		<agg:write_quote productType="LIFE" rootPath="life"/>

		<%-- Save Email Data --%>		
		<c:set var="marketing">
			<c:choose>
				<c:when test="${empty data.ip.contactDetails.optIn}">N</c:when>
				<c:otherwise>${data.ip.contactDetails.optIn}</c:otherwise>
			</c:choose>
		</c:set>
		<c:if test="${not empty data.ip.contactDetails.email}">
			<agg:write_email
				brand="CTM"
				vertical="IP"
				source="QUOTE"
				emailAddress="${data.ip.contactDetails.email}"
				firstName="${data.ip.details.primary.firstName}"
				lastName="${data.ip.details.primary.lastname}"
				items="marketing=${marketing},okToCall=${data.ip.contactDetails.call}" />
		</c:if>
		
		<%-- add external testing ip address checking and loading correct config and send quotes --%>
		<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />
		
		<c:set var="tranId" value="${data.current.transactionId}" />
		
		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/life/config_request_call.xml" />
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}" 
							xml = "${data.xml['life']}" 
							var = "resultXml"
							debugVar="debugXml" />
							
		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />

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
