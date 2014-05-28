<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:catch var="error">
<sql:setDataSource dataSource="jdbc/aggregator"/>
<settings:setVertical verticalCode="GENERIC" />

	<jsp:useBean id="unsubscribe" class="com.ctm.model.Unsubscribe" scope="session" />

	<c:set var="vertical" value="${fn:toLowerCase(unsubscribe.getVertical())}" />

<c:choose>
		<c:when test="${unsubscribe.getEmailDetails().isValid()}">
		<agg:write_email_properties
					vertical="${vertical}"
			items="marketing=N"
					emailId="${unsubscribe.getEmailDetails().getEmailId()}"
					email="${unsubscribe.getEmailDetails().getEmailAddress()}"
			stampComment="UNSUBSCRIBE_PAGE" />
	</c:when>
	<c:otherwise>
		{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldn’t unsubscribe you. Please try again."}
	</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${not empty error}">
	<go:log error="${error}" level="ERROR" source="ajax_json_unsubscribe_jsp">failed to unsubscribe ${unsubscribe.getEmailDetails().getEmailAddress()}</go:log>
	{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldnâ€™t unsubscribe you. Please try again."}
</c:if>
