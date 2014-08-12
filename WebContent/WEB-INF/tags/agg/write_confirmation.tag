<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write confirmation data to the database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="transaction_id"		required="true"		rtexprvalue="true"	description="The transaction ID" %>
<%@ attribute name="confirmation_key"	required="true"		rtexprvalue="true"	description="The confirmation ID" %>
<%@ attribute name="vertical"			required="true"		rtexprvalue="true"	description="The vertical" %>
<%@ attribute name="xml_data"			required="false"	rtexprvalue="true"	description="XML data if applicable" %>

<%-- VARIABLES --%>
<c:if test="${empty xml_data}">
	<c:set var="xml_data" value="none" />
</c:if>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%-- Save the form information to the database  --%>
<c:catch var="error">
	<sql:update var="result">
		INSERT INTO ctm.`confirmations`
		(TransID, KeyID, Time, XMLdata) VALUES (?, ?, NOW(), ?);
		<sql:param value="${transaction_id}" />
		<sql:param value="${confirmation_key}" />
		<sql:param value="${xml_data}" />
	</sql:update>
</c:catch>

<c:if test="${not empty error}">
	<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
		<c:param name="transactionId" value="${transaction_id}" />
		<c:param name="page" value="${pageContext.request.servletPath}" />
		<c:param name="message" value="Failed to write homeloan confirmation record." />
		<c:param name="description" value="${error}" />
		<c:param name="data" value="confirmation_key=${confirmation_key}" />
	</c:import>
</c:if>