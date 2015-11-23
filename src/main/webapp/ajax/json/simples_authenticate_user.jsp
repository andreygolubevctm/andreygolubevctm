<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated  />
<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />

<c:set var="authenticated">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>
{"authenticated":${authenticated}}