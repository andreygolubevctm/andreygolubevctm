<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="vertical">${param.vertical}</c:set>
<c:if test="${vertical == 'main'}">
	<c:set var="vertical">frontend</c:set>
</c:if>

<c:if test="${not empty data['settings/vertical']}">
	<c:set var="originalVertical" value="${data['settings/vertical']}" />
</c:if>

<core:load_settings conflictMode="false" vertical="${vertical}"/>

<core:comparison_reminder src="${param.src}" vertical="${param.vertical}" loadjQuery="${param.loadjQuery}" loadjQueryUI="${param.loadjQueryUI}" loadHead="${param.loadHead}" preSelect="${param.preselect}" id="${param.id}"/>

<core:load_settings conflictMode="false" vertical="${originalVertical}"/>