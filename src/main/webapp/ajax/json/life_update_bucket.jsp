<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" />

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.life_update_bucket')}" />

<c:set var="clientUserAgent"><%=request.getHeader("user-agent")%></c:set>
<c:set var="vertical"><c:out value="${param.vertical}" escapeXml="true" /></c:set>

<session:get settings="true" authenticated="true" verticalCode="${fn:toUpperCase(vertical)}" />

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core_v1:access_check quoteType="${fn:toLowerCase(vertical)}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		${logger.debug('PROCEEDINATOR PASSED. {}' , log:kv('proceedinator',proceedinator ))}

		<%-- Let's safely store the calcSequence and transactionId so we can add it back in after --%>
		<c:set var="calcSequence" value="${data[vertical].calcSequence}" />
		<c:set var="transactionId" value="${data[vertical].transactionId}" />

		<%-- Load the params into data --%>
		<security:populateDataFromParams rootPath="${vertical}" />

		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/clientIpAddress" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/clientUserAgent" value="${clientUserAgent}" />

		<%-- Save client data --%>
		<c:if test="${empty param.updateBucket or param.updateBucket eq 'true'}">
			<agg_v1:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${fn:toLowerCase(vertical)}"/>
		</c:if>

		<%-- Add calcSequence and transactionId back in --%>
		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/calcSequence" value="${calcSequence}" />
		<go:setData dataVar="data" xpath="${fn:toLowerCase(vertical)}/transactionId" value="${transactionId}" />
	</c:when>
	<c:otherwise><%-- IGNORE GRACEFULLY --%></c:otherwise>
</c:choose>