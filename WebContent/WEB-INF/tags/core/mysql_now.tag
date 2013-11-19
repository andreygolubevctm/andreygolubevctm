<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Returns the current datetime of mySQL"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:catch var="error">
	<sql:query var="mysqlnow">
		SELECT Now() AS today;
	</sql:query>
</c:catch>

<c:choose>
	<c:when test="${empty error and mysqlnow.rowCount > 0}">${mysqlnow.rows[0].today}</c:when>
	<c:otherwise>0000-00-00 00:00:00</c:otherwise>
</c:choose>