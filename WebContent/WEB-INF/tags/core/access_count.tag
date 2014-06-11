<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checks the transactions access history to determine the count of a particular touch type"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="touch" 	required="true"	rtexprvalue="true" 	description="Touch type (single character) e.g. N, R" %>

<%-- VARIABLES --%>
<c:set var="reserved_name" value="another user" />

<c:if test="${empty isSimplesUser or not isSimplesUser eq true}">
	<c:set var="isSimplesUser" value="${false}" />
</c:if>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:catch var="error">
	<sql:query var="touches">
		SELECT `id`
		FROM ctm.touches
		WHERE `transaction_id`  = ?
		AND `type` = ?
		<sql:param value="${data.current.transactionId}" />
		<sql:param value="${touch}" />
	</sql:query>
</c:catch>

<c:set var="access_count">
	<c:choose>
		<c:when test="${empty error and not empty touches and touches.rowCount > 0}">${touches.rowCount}</c:when>
		<c:otherwise>${0}</c:otherwise>
	</c:choose>
</c:set>

${access_count}