<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:log>Writing Quote Data</go:log>
			
<%-- Return the transaction Id --%>
<c:out value="${data['current/transactionId']}" />