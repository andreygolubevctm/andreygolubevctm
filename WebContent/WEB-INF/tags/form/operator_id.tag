<%@ tag description="The reference number aka transaction number for the quote"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="operatorid">
	<c:choose>
		<c:when test="${not empty data.login.user.uid}">${data.login.user.uid}</c:when>
		<c:when test="${not empty data[xpath]}">${data[xpath]}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" value="${operatorid}">