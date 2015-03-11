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
			<jsp:useBean id="accessTouchService" class="com.ctm.services.AccessTouchService" scope="page" />
			<c:set var="accessTouch"  value="${accessTouchService.getLatestAccessTouchByTransactionId(data.current.transactionId, authenticatedData.login.user.uid)}" scope="request" />
		</c:catch>

		<c:set var="access_check">
			<c:choose>
				<c:when test="${not empty error}">${0}<go:log error="${error}" level="ERROR" source="access_check_tag" /></c:when>
				<c:otherwise>${accessTouch.getAccessCheck().getCode()}</c:otherwise>
			</c:choose>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="access_check" value="${1}" />
	</c:otherwise>

</c:choose>

${access_check}