<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checks the transactions access history to determine whether it is accessible"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="now" class="java.util.Date"/>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 	required="true"		rtexprvalue="true"	description="The vertical this quote is for"%>
<%@ attribute name="tranid" 	required="false"	rtexprvalue="true" 	description="Transaction ID to test otherwise use that in data bucket" %>

<c:set var="id_to_check">
	<c:choose>
		<c:when test="${not empty tranid}">${tranid}</c:when>
		<c:otherwise>${data.current.transactionId}</c:otherwise>
	</c:choose>
</c:set>

<%-- Only perform check for the health vertical - otherwise return 1 to pass the test. --%>

<c:choose>
	<c:when test="${quoteType == ''}">
		<c:set var="access_check" value="${0}" />
		<go:log source="core:access_check">quote type must have a value '${quoteType}'</go:log>
	</c:when>
	<c:when test="${fn:toLowerCase(quoteType) == 'health'}">
		<go:log source="core:access_check">before import: ${id_to_check}</go:log>
		<%-- IMPORTS --%>
		<c:set var="sandpit">
			<core:get_transaction_id quoteType="${quoteType}" id_handler="preserve_tranId" emailAddress="" transactionId="${id_to_check}" />
		</c:set>

		<go:log source="core:access_check">after import: ${data.current.transactionId}</go:log>

		<%-- VARIABLES --%>
		<c:set var="access_check" value="${false}" />

		<sql:setDataSource dataSource="jdbc/ctm"/>

		<c:catch var="error">
			<sql:query var="touches">
				SELECT `operator_id`, `type`, IF(TIMESTAMP(NOW() - INTERVAL 45 MINUTE) > TIMESTAMP(CONCAT(date, ' ', time)), 1, 0) AS expired
				FROM ctm.touches AS tch
				WHERE `transaction_id`  = ?
				ORDER BY `id` DESC, `date` DESC, `time` DESC
				LIMIT 1;
				<sql:param value="${data.current.transactionId}" />
			</sql:query>
		</c:catch>

		<c:set var="access_check">
			<c:choose>
				<c:when test="${not empty error}">${0}</c:when>
				<c:when test="${empty touches or touches.rowCount eq 0}">${1}</c:when>
				<c:when test="${not empty touches and touches.rowCount > 0}">
					<c:choose>
						<c:when test="${touches.rows[0].expired eq 1}">${2}</c:when>
						<c:when test="${touches.rows[0].type eq 'X'}">${3}</c:when>
						<c:when test="${touches.rows[0].operator_id eq 'ONLINE'}">${4}</c:when>
						<c:when test="${touches.rows[0].operator_id eq authenticatedData.login.user.uid}">${5}</c:when>
						<c:otherwise>${0}</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>${0}</c:otherwise>
			</c:choose>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="access_check" value="${1}" />
		<go:log source="core:access_check">not performed for '${quoteType}'</go:log>
	</c:otherwise>

</c:choose>



${access_check}