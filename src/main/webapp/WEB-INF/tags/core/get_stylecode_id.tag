<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Fetch stylecode id from transaction id"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="transactionId"	required="true" rtexprvalue="true"	description="" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<sql:query var="styleCode">
	SELECT styleCodeID FROM ctm.transaction_stylecode where transactionID = ?
	<sql:param value="${transactionId}" />
</sql:query>

${styleCode.rows[0].styleCodeID}