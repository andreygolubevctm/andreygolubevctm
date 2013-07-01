<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:choose>
	<c:when test="${param.id eq 'robe'}">
		<c:redirect url="https://secure.comparethemarket.com.au/ctm/robe_competition.jsp"/>
	</c:when>
	<c:otherwise>
		<c:redirect url="https://secure.comparethemarket.com.au/ctm/robe_competition.jsp"/>
	</c:otherwise>
</c:choose>