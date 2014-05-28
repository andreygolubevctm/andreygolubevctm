<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="${param.vertical}" />

<%-- 1. Attempt to load quote into session and get JSON object containing load details --%>
<c:import var="loadQuoteJSON" url="/ajax/json/remote_load_quote.jsp?action=load&vertical=${param.vertical}&transactionId=${param.id}&hash=${param.hash}&type=${type}" />

<%-- 2. Check JSON contains destination URL --%>
<c:set var="loadQuoteXML">${go:JSONtoXML(loadQuoteJSON)}</c:set>
<x:parse doc="${loadQuoteXML}" var="loadQuote" />
<c:set var="redirect">
	<x:out select="$loadQuote/result/destUrl" />
</c:set>
<c:set var="error">
	<x:out select="$loadQuote/result/error" />
</c:set>

<%-- 3. Redirect to destination URL or Retrieve Quotes page on failure --%>
<c:choose>
	<c:when test="${empty error and not empty redirect}">
		<c:redirect url="${go:replaceAll(redirect, '&amp;' ,'&')}" />
	</c:when>
	<c:otherwise>
		<c:if test="${not empty error}">
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="transactionId" value="${data.current.transactionId}" />
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="Failed to load transaction from email link." />
				<c:param name="description" value="${error}" />
				<c:param name="data" value="action=load&vertical=${param.vertical}&transactionId=${param.id}&hash=${param.hash}" />
			</c:import>
		</c:if>
		<c:redirect url="/retrieve_quotes.jsp" />
	</c:otherwise>
</c:choose>