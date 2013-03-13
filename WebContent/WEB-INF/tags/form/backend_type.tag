<%@ tag description="The reference number aka transaction number for the quote"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="backend_type">
	<c:choose>
		<c:when test="${not empty data.backend_type}">${data.backend_type}</c:when>
		<c:when test="${not empty data[xpath]}">${data[xpath]}</c:when>
		<c:otherwise>mysql</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" value="${backend_type}">