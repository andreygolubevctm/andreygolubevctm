<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<core:load_settings conflictMode="false"/>

<c:choose>
	<c:when test="${param.id eq 'robe'}">
		<%-- <c:redirect url="${data['settings/root-url']}${data['settings/styleCode']}/robe_competition.jsp" /> --%>
		<c:redirect url="http://www.comparethemeerkat.com.au/" />
	</c:when>
	<c:when test="${param.id eq 'grub'}">
		<%--<c:redirect url="${data['settings/root-url']}${data['settings/styleCode']}/october_promo.jsp" /> --%>
		<c:redirect url="http://www.comparethemeerkat.com.au/" />
	</c:when>
	<c:when test="${param.id eq 'christmas'}">
		<c:redirect url="${data['settings/root-url']}${data['settings/styleCode']}/christmas_promo.jsp?firstname=${param.firstname}&email=${param.email}&postcode=${param.postcode}&marketing=${param.marketing}" />
<%-- 		<c:redirect url="http://www.comparethemeerkat.com.au/" /> --%>
	</c:when>
	<c:otherwise>
		<c:redirect url="${data['settings/exit-url']}" />
	</c:otherwise>
</c:choose>