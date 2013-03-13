<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Creates a select box of all the users"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"  rtexprvalue="true"	 description="title of the select box" %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="result">
	SELECT *
	FROM ctm.users
	WHERE `branch` = ?
	<sql:param value="${data.login.user.branch}" />
</sql:query>

<c:set var="userItems" value="=Please select...||" />

<c:forEach var="row" items="${result.rows}" varStatus="status">
	<c:set var="userItems">${userItems}${row.uid}=${row.uid}<c:if test="${not status.last}">||</c:if></c:set>
</c:forEach>

<field:array_select items="${userItems}" required="${required}" title="${title}" xpath="${xpath}" className="${className}" delims="||" />