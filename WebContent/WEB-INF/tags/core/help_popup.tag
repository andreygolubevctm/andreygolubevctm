<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Create help popup tag"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="true"	 rtexprvalue="true"	 description="dialogueId for helptext table" %>
<%@ attribute name="title" 		required="false" rtexprvalue="false" description="optional title for help popup" %>
<%@ attribute name="text" 		required="false" rtexprvalue="false" description="optional text for help popup" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>

<%-- CODE --%>
<div class="help_text ui-widget ui-dialog ui-corner-all ${className}">
	<c:choose>
		<c:when test="${id != ''}">
			<sql:setDataSource dataSource="jdbc/test"/>
			<sql:query var="result">
				SELECT dialogue
				FROM dialogue
				WHERE type = "help"
					AND dialogueId=? LIMIT 1
				<sql:param>${id}</sql:param>
			</sql:query>
			<c:if test="${result.rowCount > 0}">
				${result.rows[0].dialogue}
			</c:if>		
		</c:when>
		<c:otherwise>
			<h3>${title}</h3>${text}
		</c:otherwise>
	</c:choose>
</div>