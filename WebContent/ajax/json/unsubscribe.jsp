<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="hashedEmail" value="${param.hashedEmail}" />
<c:set var="brand" value="${param.brand}" />
<c:set var="vertical" value="${param.vertical}" />

<%-- check if the hashed email exists --%>
<c:set var="email"><security:hashed_email action="decrypt" email="${hashedEmail}" brand="${brand}" /></c:set>

<c:choose>
	<c:when test="${email ne 'false'}">
		
		<agg:write_email_properties
			vertical="${fn:toLowerCase(vertical)}"
			items="marketing=N"
			email="${email}"
			brand="${fn:toLowerCase(brand)}"
			stampComment="UNSUBSCRIBE_PAGE" />
		
	</c:when>
	<c:otherwise>
		{error: true, errorMsg: "Oops, something seems to have gone wrong! We couldn’t unsubscribe you. Please try again."}
	</c:otherwise>
</c:choose>