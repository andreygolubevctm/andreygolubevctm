<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<c:set var="vertical"><c:out value="${param.vertical}" escapeXml="true"/></c:set>
<c:set var="src"><c:out value="${param.src}" escapeXml="true"/></c:set>
<c:set var="loadjQuery"><c:out value="${param.loadjQuery}" escapeXml="true"/></c:set>
<c:set var="loadjQueryUI"><c:out value="${param.loadjQueryUI}" escapeXml="true"/></c:set>
<c:set var="loadHead"><c:out value="${param.loadHead}" escapeXml="true"/></c:set>
<c:set var="preselect"><c:out value="${param.preselect}" escapeXml="true"/></c:set>
<c:set var="id"><c:out value="${param.id}" escapeXml="true"/></c:set>

<c:if test="${vertical == 'main' || vertical == ''}">
	<c:set var="vertical">GENERIC</c:set>
</c:if>

<session:new verticalCode="${vertical}" />

<core:comparison_reminder src="${src}" vertical="${vertical}" loadjQuery="${loadjQuery}" loadjQueryUI="${loadjQueryUI}"
		loadHead="${loadHead}" preSelect="${preselect}" id="${id}"/>
