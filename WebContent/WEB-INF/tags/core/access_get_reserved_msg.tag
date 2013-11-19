<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checks the transactions access history to determine whether it is accessible"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="now" class="java.util.Date"/>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%@ attribute name="isSimplesUser" 	required="false"	rtexprvalue="true" 	description="Boolean flag as to whether simples user." %>

<%-- VARIABLES --%>
<c:set var="reserved_name" value="another user" />  

<c:if test="${empty isSimplesUser or not isSimplesUser eq true}">
	<c:set var="isSimplesUser" value="${false}" />
</c:if>

<%--ONLY UPDATE RESERVED_NAME IF SIMPLES USER --%>
<c:if test="${isSimplesUser}">
	<sql:setDataSource dataSource="jdbc/ctm"/>
	
	<c:catch var="error">
		<sql:query var="touches">
			SELECT *, IF(TIMESTAMP(NOW() - INTERVAL 45 MINUTE) > TIMESTAMP(CONCAT(date, ' ', time)), 1, 0) AS expired
			FROM ctm.touches AS tch
			WHERE `transaction_id`  = ?
			ORDER BY `id` DESC, `date` DESC, `time` DESC
			LIMIT 1;
			<sql:param value="${data.current.transactionId}" />
		</sql:query>
	</c:catch>
	
	<c:set var="access_check">
		<c:choose>
			<c:when test="${not empty error}">${false}</c:when>
			<c:when test="${empty touches or touches.rowCount eq 0}">${false}</c:when>
			<c:when test="${not empty touches and touches.rowCount > 0}">${true}</c:when>
			<c:otherwise>${false}</c:otherwise>
		</c:choose>
	</c:set>
	
	<c:if test="${access_check}">
		<c:set var="reserved_name">${touches.rows[0].operator_id}</c:set>
	</c:if>
</c:if>
This quote has been reserved by ${reserved_name}. Please try again later.