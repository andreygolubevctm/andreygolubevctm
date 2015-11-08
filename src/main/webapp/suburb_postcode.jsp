<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical">${param.vertical}</c:set>
<settings:setVertical verticalCode="${param.vertical}" />

<core:wrapper jqueryuiversion="1.10.4" loadjQuery="${param.loadjQuery}" loadjQueryUI="${param.loadjQueryUI}" loadHead="${param.loadHead}" vertical="${vertical}" id="${param.id}" loadCSS="${param.loadCSS}" loadExtJs="${param.loadExtJs}">
	<field:suburb_postcode id="${param.id}" placeholder="${param.placeholder}" xpath="${param.id}_location" required="true" title="Postcode/Suburb" />
</core:wrapper>