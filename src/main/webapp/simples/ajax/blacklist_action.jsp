<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<jsp:useBean id="simplesService" class="com.ctm.services.simples.SimplesBlacklistService" scope="page" />
<settings:setVertical verticalCode="SIMPLES" />
<session:getAuthenticated />

<c:set var="channel" value="${param.channel}" />
<c:set var="value" value="${param.value}" />
<c:set var="comment" value="${param.comment}" />
<c:set var="action" value="${param.action}" />
<c:set var="success" value="false" />
<c:set var="operator" value="${authenticatedData['login/user/uid']}" />

<c:choose>
	<c:when test="${action == 'add'}">
		<c:set var="success" value="${simplesService.addToBlacklist(pageContext.getRequest(), channel, value, operator, comment)}" />
	</c:when>
	<c:when test="${action == 'delete'}">
		<c:set var="success" value="${simplesService.deleteFromBlacklist(pageContext.getRequest(), channel, value, operator, comment)}" />
	</c:when>
</c:choose>

<c:choose>
	<c:when test="${success eq true}">
		<%-- JSON RESPONSE SUCCESS--%>
		<json:object>
			<json:property name="successMessage" value="${action} in blacklist for ${value} [${channel}] successful" />
		</json:object>
	</c:when>
	<c:otherwise>
		<%-- JSON RESPONSE FAIL--%>
		<json:object>
			<c:choose>
				<c:when test="${action == 'add'}">
					<json:property name="errorMessage" value="${value} [${channel}] is already in the blacklist." />
				</c:when>
				<c:when test="${action == 'delete'}">
					<json:property name="errorMessage" value="Couldn't find ${value} [${channel}] in the blacklist." />
				</c:when>
			</c:choose>
		</json:object>
	</c:otherwise>
</c:choose>