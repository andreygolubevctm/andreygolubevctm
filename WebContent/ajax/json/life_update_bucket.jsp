<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>
<c:set var="vertical"><c:out value="${param.vertical}" escapeXml="true" /></c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core:access_check quoteType="${fn:toLowerCase(vertical)}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		<go:log>PROCEEDINATOR PASSED</go:log>

		<%-- Let's safely store the calcSequence and transactionId so we can add it back in after --%>
		<c:set var="calcSequence" value="${data[vertical].calcSequence}" />
		<c:set var="transactionId" value="${data[vertical].transactionId}" />

		<%-- Load the params into data --%>
		<security:populateDataFromParams rootPath="${vertical}" />

		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/clientIpAddress" value="${pageContext.request.remoteAddr}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/clientUserAgent" value="${clientUserAgent}" />

		<%-- Save client data --%>
		<agg:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${fn:toLowerCase(vertical)}"/>

		<%-- Add calcSequence and transactionId back in --%>
		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/calcSequence" value="${calcSequence}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/transactionId" value="${transactionId}" />
	</c:when>
	<c:otherwise><%-- IGNORE GRACEFULLY --%></c:otherwise>
</c:choose>