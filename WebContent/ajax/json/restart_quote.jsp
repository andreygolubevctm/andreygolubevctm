<%@ page language="java" contentType="text/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:log>RESTART QUOTE: ${param}</go:log>

<c:set var="vertical" value="${param.quoteType}" />

<go:setData dataVar="data" value="*DELETE" xpath="quote" />
<go:setData dataVar="data" value="*DELETE" xpath="${vertical}" />
		
<c:set var="result">
	<result>
		<destUrl>${vertical}_quote.jsp</destUrl>
	</result>
</c:set>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}