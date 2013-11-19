<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Retrieve dialogue text"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="type" 		required="true"	 rtexprvalue="true"	 description="type code on dialogue table" %>
<%@ attribute name="id" 		required="true"	 rtexprvalue="true"	 description="dialogueId on dialogue table" %>

<%-- CODE --%>
<sql:setDataSource dataSource="jdbc/test"/>
<sql:query var="result">
SELECT dialogue FROM dialogue
WHERE type = ?
AND dialogueId=? LIMIT 1
<sql:param value="${type}" />
<sql:param value="${id}" />
</sql:query>

<c:if test="${result.rowCount > 0}">
	<c:out value="${result.rows[0].dialogue}" />
</c:if>