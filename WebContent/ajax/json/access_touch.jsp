<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:log>quoteType: ${param.quoteType}</go:log>
<c:set var="proceedinator"><core:access_check quoteType="${param.quoteType}" /></c:set>
<c:if test="${empty proceedinator}">
	<c:set var="proceedinator">${0}</c:set>
</c:if>

<%--
	These are the touch types that are allowed via ajax.
	All other touches need to be done using <core:transaction touch="?" />
--%>
<c:set var="valid_touches" value="A.E.F.H.S.X.CB." />
<c:set var="validate_touch" value="${param.touchtype}." />
<c:if test="${empty param.touchtype or !fn:contains(valid_touches, validate_touch)}">
	<c:set var="proceedinator">99</c:set>
</c:if>

<c:set var="result">
<result>
	<success>${proceedinator}</success>
	<c:choose>
		<c:when test="${proceedinator eq 0}">
			<message><core:access_get_reserved_msg isSimplesUser="${not empty data.login.user.uid}" /></message>
		</c:when>
		<c:when test="${proceedinator eq 99}">
			<message>Invalid touch type.</message>
		</c:when>
		<c:otherwise>
			<core:transaction touch="${param.touchtype}" comment="${param.comment}" noResponse="true" />
		</c:otherwise>
	</c:choose>
	<transactionId>${data.current.transactionId}</transactionId>
</result>
</c:set>

<%-- Return the results as json --%>
${go:XMLtoJSON(result)}