<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:delete transactionId="${param.transactionId}" />

<go:log  level="INFO" >RESTART QUOTE: ${param}</go:log>

<c:set var="vertical" value="${param.quoteType}" />

<c:set var="result">
	<result>
		<destUrl>${vertical}_quote.jsp</destUrl>
	</result>
</c:set>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}