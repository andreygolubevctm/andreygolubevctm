<%@ page language="java" contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated  />


<?xml version="1.0" encoding="UTF-8"?>
<example>
	<c:if test="${not fn:startsWith(clientIp,'192.168.')}">
		${authenticatedData}
	</c:if>
</example>