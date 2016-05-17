<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<jsp:useBean id="messageDao" class="com.ctm.web.simples.dao.MessageDao" scope="page" />

<c:set var="parentStatusId" value="${param.parentStatusId}" />
<c:set var="heading" value="${param.heading}" />

<json:object>
	<json:property name="heading" value="${heading}"/>
	<json:array name="statuses" var="status" items="${messageDao.getStatuses(parentStatusId)}">
		<json:object>
			<json:property name="id" value="${status.getId()}" />
			<json:property name="status" value="${status.getStatus()}" />
		</json:object>
	</json:array>
</json:object>