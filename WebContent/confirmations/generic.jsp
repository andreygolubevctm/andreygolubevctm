<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<layout:generic_confirmation_page title="Confirmation Page">

	<jsp:attribute name="header">
	</jsp:attribute>

	<jsp:attribute name="form_bottom">
	</jsp:attribute>

	<jsp:attribute name="footer">
	</jsp:attribute>

	<jsp:attribute name="body_end">
	</jsp:attribute>

	<jsp:body>
		<p>Thanks for comparing with <content:get key="brandDisplayName"/>.</p>
		<p>Your reference number is <c:out escapeXml="true" value="${param.transactionId}"/>.</p>
	</jsp:body>
</layout:generic_confirmation_page>