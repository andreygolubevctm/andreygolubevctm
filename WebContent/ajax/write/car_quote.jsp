<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:log>Writing Quote Data</go:log>
			
<%-- Return the transaction Id --%>
<c:out value="${data['current/transactionId']}" />