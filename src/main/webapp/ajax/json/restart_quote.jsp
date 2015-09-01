<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${go:getLogger('restart_quote_jsp')}" />

<session:delete transactionId="${param.transactionId}" />
${logger.info('RESTART QUOTE: param={}',param)}

<c:set var="vertical" value="${param.quoteType}" />

<c:set var="result">
	<result>
		<destUrl>${vertical}_quote.jsp</destUrl>
	</result>
</c:set>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}