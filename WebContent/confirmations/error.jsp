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
		<c:choose>
		    <c:when test="${pageSettings.getVerticalCode() == 'generic'}">
				<c:set var="exitUrl" value="${pageSettings.getSetting('exitUrl')}" />
				<c:set var="verticalName" value="" />
			</c:when>
			<c:otherwise>
				<c:set var="exitUrl" value="${pageSettings.getBaseUrl()}${pageSettings.getSetting('quoteUrl')}" />
				<c:set var="verticalName" value=" ${pageSettings.getVertical().getName()}" />
			</c:otherwise>
		</c:choose>

		<c:choose>
			<c:when test="${pageSettings.getVerticalCode() == 'placeholder if we know person arrived via email link'}">
				<p>Oops, something seems to have gone wrong! Sorry about that.</p>
				<p>If you're looking for the confirmation for your ${verticalName} application, you'll need to access this from the email we sent you.</p>
				<p>Otherwise head back to <a href="exitUrl}">${fn:replace(fn:substring(exitUrl,0,fn:length(exitUrl) - 1),'http://','')}</a> to start comparing.</p>
			</c:when>
			<c:otherwise>
				<p>Oops, something seems to have gone wrong! Sorry about that.</p>
				<p>Head back to <a href="${exitUrl}">${fn:replace(fn:substring(exitUrl,0,fn:length(exitUrl) - 1),'http://','')}</a> or start a new quote by selecting an icon below.</p>				
			</c:otherwise>
		</c:choose>
	</jsp:body>
</layout:generic_confirmation_page>