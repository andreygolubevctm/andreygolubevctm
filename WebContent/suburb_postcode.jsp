<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="vertical">${param.vertical}</c:set>

<core:load_settings conflictMode="false" vertical="${vertical}"/>

<core:wrapper loadjQuery="${param.loadjQuery}" loadjQueryUI="${param.loadjQueryUI}" loadHead="${param.loadHead}" vertical="${vertical}" id="${param.id}" loadCSS="${param.loadCSS}" loadExtJs="${param.loadExtJs}">
	<field:suburb_postcode id="${param.id}" placeholder="${param.placeholder}" xpath="${param.id}_location" required="true" title="Postcode/Suburb" />
</core:wrapper>