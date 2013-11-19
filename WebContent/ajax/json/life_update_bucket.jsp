<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${fn:toLowerCase(param.vertical)}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Let's safely store the calcSequence and transactionId so we can add it back in after --%>
		<c:set var="calcSequence" value="${data[param.vertical].calcSequence}" />
		<c:set var="transactionId" value="${data[param.vertical].transactionId}" />

		<%-- Load the params into data --%>
		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}" value="*DELETE" />
		<go:setData dataVar="data" value="*PARAMS" />

		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}/clientUserAgent" value="${clientUserAgent}" />

		<%-- Save client data --%>
		<agg:write_quote productType="${fn:toUpperCase(param.vertical)}" rootPath="${fn:toLowerCase(param.vertical)}"/>

		<%-- Add calcSequence and transactionId back in --%>
		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}/calcSequence" value="${calcSequence}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(param.vertical)}/transactionId" value="${transactionId}" />
	</c:when>
	<c:otherwise><%-- IGNORE GRACEFULLY --%></c:otherwise>
</c:choose>