<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Checks the transactions access history to determine whether it is accessible"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" 	required="true"		rtexprvalue="true"	description="The vertical this quote is for"%>
<%@ attribute name="tranid" 	required="false"	rtexprvalue="true" 	description="Transaction ID to test otherwise use that in data bucket" %>

<jsp:useBean id="accessTouchService" class="com.ctm.web.core.services.AccessCheckService" scope="page" />

<c:set var="id_to_check">
	<c:choose>
		<c:when test="${not empty tranid}">${tranid}</c:when>
		<c:otherwise>${data.current.transactionId}</c:otherwise>
	</c:choose>
</c:set>

<%-- TODO move this over to accessTouchService --%>
<c:if test="${fn:toLowerCase(quoteType) == 'health'}">
	<c:set var="sandpit">
		<core:get_transaction_id quoteType="${quoteType}" id_handler="preserve_tranId" emailAddress="" transactionId="${id_to_check}" />
	</c:set>
</c:if>

<%-- check the user has access if the user is an operator and has access this will add a lock to transaction lock table --%>
${accessTouchService.getAccessCheckCode(data.current.transactionId , authenticatedData.login.user.uid, quoteType)}