<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:catch var="error">
<sql:setDataSource dataSource="jdbc/aggregator"/>

<settings:setVertical verticalCode="GENERIC" />

<c:set var="hashedEmail" value="${param.hashedEmail}" />
<c:set var="brand" value="${param.brand}" />
<c:set var="vertical" value="${param.vertical}" />

<%-- check if the hashed email exists --%>
<c:set var="email"><security:hashed_email action="decrypt" email="${hashedEmail}" brand="${brand}" /></c:set>

<%-- #WHITELABEL hashed_email can also return the distinct emailId --%>
<%-- #WHITELABEL This should be using brandcode somehow --%>
<c:set var="emailId"><security:hashed_email action="decrypt" email="${hashedEmail}" brand="${brand}" output="id" /></c:set>

<c:choose>
	<c:when test="${email ne 'false'}">
		<agg:write_email_properties
			vertical="${fn:toLowerCase(vertical)}"
			items="marketing=N"
					emailId="${emailId}"
			email="${email}"
			brand="${fn:toLowerCase(brand)}"
			stampComment="UNSUBSCRIBE_PAGE" />
	</c:when>
	<c:otherwise>
		{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldn’t unsubscribe you. Please try again."}
	</c:otherwise>
	</c:choose>
</c:catch>
<c:if test="${not empty error}">
	<go:log error="${email}" level="ERROR" source="ajax_json_unsubscribe_jsp">failed to unsubscribe ${email}</go:log>
	{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldnâ€™t unsubscribe you. Please try again."}
</c:if>
