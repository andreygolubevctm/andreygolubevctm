<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>
<c:set var="vertical" value="${fn:trim(fn:toLowerCase(param.vertical))}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${vertical}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Load the params into data --%>
		<security:populateDataFromParams rootPath="${vertical}" />

		<go:setData dataVar="data" xpath="${vertical}/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="${vertical}/clientUserAgent" value="${clientUserAgent}" />

		<%-- RECOVER: if things have gone pear shaped --%>
		<c:if test="${empty data.current.transactionId}">
			<error:recover origin="ajax/json/life_quote_results.jsp" quoteType="${vertical}" />
		</c:if>

		<%-- Save client data --%>
		<core:transaction touch="R" noResponse="true" />

		<%-- add external testing ip address checking and loading correct config and send quotes --%>
		<c:set var="clientIpAddress" value="<%=request.getRemoteAddr()%>" />

		<c:set var="tranId" value="${data.current.transactionId}" />
		<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${tranId}" />
		<%-- Load the config and send quotes to the aggregator gadget --%>
		<c:import var="config" url="/WEB-INF/aggregator/life/config_results_${vertical}.xml" />
		<go:soapAggregator config = "${config}"
							transactionId = "${tranId}"
							xml = "${go:getEscapedXml(data[vertical])}"
							var = "resultXml"
							debugVar="debugXml" />

		<%-- //FIX: turn this back on when you are ready!!!!
		<%-- Write to the stats database --%>
		<life:write_stats rootPath="${vertical}" tranId="${tranId}" debugXml="${debugXml}" />

		<%-- Add the results to the current session data --%>
		<go:setData dataVar="data" xpath="soap-response" value="*DELETE" />
		<go:setData dataVar="data" xpath="soap-response" xml="${resultXml}" />
		<go:setData dataVar="data" xpath="soap-response/results/transactionId" value="${tranId}" />

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
${go:XMLtoJSON(go:getEscapedXml(data['soap-response/results']))}
