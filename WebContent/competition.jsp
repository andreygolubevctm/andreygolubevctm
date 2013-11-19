<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Don't override settings --%>
<c:if test="${empty data.settings.styleCode}">
	<c:import url="brand/ctm/settings.xml" var="settingsXml" />
	<go:setData dataVar="data" value="*DELETE" xpath="settings" />
	<go:setData dataVar="data" xml="${settingsXml}" />
</c:if>

<c:choose>
	<c:when test="${param.id eq 'robe'}">
		<%-- <c:redirect url="${data['settings/root-url']}${data['settings/styleCode']}/robe_competition.jsp" /> --%>
		<c:redirect url="http://www.comparethemeerkat.com.au/" />
	</c:when>
	<c:when test="${param.id eq 'grub'}">
		<%--<c:redirect url="${data['settings/root-url']}${data['settings/styleCode']}/october_promo.jsp" /> --%>
		<c:redirect url="http://www.comparethemeerkat.com.au/" />
	</c:when>
	<c:otherwise>
		<c:redirect url="${data['settings/exit-url']}" />
	</c:otherwise>
</c:choose>