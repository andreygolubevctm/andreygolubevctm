<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical">${param.vertical}</c:set>
<c:if test="${vertical == 'main' || vertical == ''}">
	<c:set var="vertical">GENERIC</c:set>
</c:if>

<session:new verticalCode="${vertical}" />

<core:comparison_reminder src="${param.src}" vertical="${vertical}" loadjQuery="${param.loadjQuery}" loadjQueryUI="${param.loadjQueryUI}" loadHead="${param.loadHead}" preSelect="${param.preselect}" id="${param.id}"/>
