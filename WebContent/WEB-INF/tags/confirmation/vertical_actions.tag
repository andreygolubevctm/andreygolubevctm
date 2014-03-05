<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"			required="true"		rtexprvalue="true"	description="The label for the vertical" %>
<%@ attribute name="transaction_id"		required="true"		rtexprvalue="true"	description="The transaction id" %>
<%@ attribute name="confirmation_ref"	required="true"		rtexprvalue="true"	description="The confirmation reference" %>

<%-- ACTION VERTICAL SPECIFIC EVENTS --%>
<c:choose>
	<c:when test="${vertical eq 'homeloan'}">
		<homeloan:confirmation_update transaction_id="${transaction_id}" confirmation_ref="${confirmation_ref}" />
	</c:when>
	<c:when test="${vertical eq 'homelmi'}">
		<%-- HomeLMI as it is not using the confirmation table. See PRJHNC-48. This can be uncommented if the vertical will over use the confirmation table--%>
		<homelmi:confirmation_update/>
	</c:when>

	<c:otherwise><%-- IGNORE --%></c:otherwise>
</c:choose>