<%@ page language="java" contentType="text/xml; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<?xml version="1.0" encoding="ISO-8859-1"?>
<example>
	<c:if test="${not fn:startsWith(clientIp,'192.168.')}">
		${data}
	</c:if>
</example>