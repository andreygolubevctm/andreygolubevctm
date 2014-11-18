<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:catch var="error">
	<jsp:useBean id="unsubscribe" class="com.ctm.model.Unsubscribe" scope="session" />
	<jsp:useBean id="unsubscribeService" class="com.ctm.services.UnsubscribeService" scope="request" />
	<settings:setVertical verticalCode="GENERIC" />

	<c:choose>
		<c:when test="${unsubscribe.getEmailDetails().isValid()}">
				${unsubscribeService.unsubscribe(pageSettings, unsubscribe)}
				<agg:write_stamp
					action="toggle_marketing"
					vertical="${fn:toLowerCase(unsubscribe.getVertical())}"
					value="N"
					target="${unsubscribe.getEmailDetails().getEmailAddress()}"
					comment="UNSUBSCRIBE_PAGE" />
	</c:when>
	<c:otherwise>
		{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldn’t unsubscribe you. Please try again."}
	</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${not empty error}">
	<go:log error="${error}" level="ERROR" source="ajax_json_unsubscribe_jsp">failed to unsubscribe ${unsubscribe.getEmailDetails().getEmailAddress()}</go:log>
	{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldn’t unsubscribe you. Please try again."}
</c:if>
