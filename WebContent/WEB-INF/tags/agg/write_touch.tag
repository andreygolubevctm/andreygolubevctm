<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Wrapper for all transaction touching and quote writes." %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="transaction_id" 	required="true"		description="The transaction to be touched" %>
<%@ attribute name="touch"				required="true"		description="The touch type to be applied" %>
<%@ attribute name="operator"			required="false"	description="Optional operator label (defaults to ONLINE)" %>

<%-- VARIABLES --%>
<c:if test="${empty operator}">
	<c:set var="operator" value="ONLINE" />
</c:if>

<c:catch var="error">
	<sql:update>
		INSERT INTO ctm.touches (transaction_id, date, time, operator_id, type)
		VALUES (?, NOW(), NOW(), ?, ?);
		<sql:param value="${transaction_id}" />
		<sql:param value="${operator}" />
		<sql:param value="${touch}" />
	</sql:update>
</c:catch>

<c:choose>
	<c:when test="${not empty error}">
		<go:log>agg:write_touch FAILED: ${error}</go:log>
	</c:when>
	<c:otherwise>
		<go:log>agg:write_touch TOUCHED: ${touch}</go:log>
	</c:otherwise>
</c:choose>