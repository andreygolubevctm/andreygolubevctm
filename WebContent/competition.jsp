<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<settings:setVertical verticalCode="GENERIC" />
<%-- #WHITELABEL - fix context path CTM --%>
<c:choose>
	<c:when test="${param.id eq 'robe'}">
		<%-- <c:redirect url="${pageSettings.getBaseUrl()}robe_competition.jsp" /> --%>
		<c:redirect url="${pageSettings.getSetting('exitUrl')}" />
	</c:when>
	<c:when test="${param.id eq 'grub'}">
		<%--<c:redirect url="${pageSettings.getBaseUrl()}october_promo.jsp" /> --%>
		<c:redirect url="${pageSettings.getSetting('exitUrl')}" />
	</c:when>
	<c:when test="${param.id eq 'christmas'}">
		<c:redirect url="${pageSettings.getBaseUrl()}christmas_promo.jsp?firstname=${param.firstname}&email=${param.email}&postcode=${param.postcode}&marketing=${param.marketing}" />
<%-- 		<c:redirect url="${pageSettings.getSetting('exitUrl')}" /> --%>
	</c:when>
	<c:otherwise>
		<c:redirect url="${pageSettings.getSetting('exitUrl')}" />
	</c:otherwise>
</c:choose>