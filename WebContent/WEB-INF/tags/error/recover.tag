<%@ tag description="Enables the user to be able to have a basic recovery from a lost session"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- #WHITELABEL styleCodeID --%>
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%@ attribute name="quoteType" 	required="true" rtexprvalue="true" description="The vertical (Required: will attempt to load the settings file)" %>
<%@ attribute name="origin"		required="true" rtexprvalue="true" description="Page/Tag where the recovery has been called" %>

<go:log source="error:recover">core:recover START... quoteType:${quoteType} origin:${origin}</go:log>

<c:set var="serverIp"><%
	String ip = request.getLocalAddr();
	try {
		java.net.InetAddress address = java.net.InetAddress.getLocalHost();
		ip = address.getHostAddress();
	}
	catch (Exception e) {}
%><%= ip %></c:set>

<%-- Recreate the settings and Transaction Id --%>
<c:set var="id_return">
	<core:get_transaction_id quoteType="${quoteType}" id_handler="new_tranId" />
</c:set>

<core:transaction touch="H" comment="Recover" noResponse="true" writeQuoteOverride="N" />

<c:set var="message">error:recovery quoteType=${quoteType} transactionId=${data['current/transactionId']} ipAddress=${pageContext.request.remoteAddr}</c:set>
<c:set var="code">500: serverIP=${serverIp} sessionId=<%=session.getId()%></c:set>

<%-- Log the error into the database, as this is an error recovery --%>
<c:catch var="error">
	<sql:update var="results" dataSource="jdbc/test">
		INSERT INTO test.error_log
		(styleCodeId,id, property, origin, message, code, datetime) VALUES (NULL, '${pageSettings.getBrandCode()}', ?, ?, ?, NOW());
		<sql:param value="${styleCodeId}" />
		<sql:param value="${origin}" />
		<sql:param value="${message}" />
		<sql:param value="${code}" />
	</sql:update>
</c:catch>