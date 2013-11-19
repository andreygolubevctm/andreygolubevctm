<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="proceedinator"><core:access_check quoteType="${param.quoteType}" /></c:set>
<c:if test="${empty proceedinator}">
	<c:set var="proceedinator">${0}</c:set>
</c:if>

<c:set var="result">
<result>
	<success>${proceedinator}</success>
	<c:if test="${proceedinator eq 0}">
	<message><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></message>
	</c:if>
</result>
</c:set>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}