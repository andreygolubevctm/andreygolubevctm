<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Checks the transactions access history to determine whether it is accessible"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="now" class="java.util.Date"/>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="providerId" 	required="true"		rtexprvalue="true"	description="The ID of the provider supplying the error."%>
<%@ attribute name="errorCode" 		required="true"		rtexprvalue="true" 	description="A comma delimetered list of health fund error codes." %>

<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="errorCodes" value="" />
<c:forTokens items="${errorCode}" delims="," var="ec">
	<c:if test="${errorCodes != ''}"><c:set var="errorCodes">${errorCodes},</c:set></c:if>
	<c:set var="errorCodes">${errorCodes}'${ec}'</c:set>
</c:forTokens>

<c:catch var="error">
	<sql:query var="messages">
		SELECT GROUP_CONCAT(pem.message SEPARATOR ' ') AS msg
		FROM ctm.provider_errors_messages AS pem
		RIGHT JOIN ctm.provider_errors AS pe
			ON pe.id = pem.provider_error_id
		WHERE pe.provider_id = ? AND pe.code IN (${errorCodes})
		GROUP BY pe.provider_id;
		<sql:param value="${providerId}" />
	</sql:query>
</c:catch>

<c:set var="message">
	<c:choose>
		<c:when test="${empty error and not empty messages and messages.rowCount > 0}">${messages.rows[0].msg}</c:when>
	</c:choose>
</c:set>

${message}