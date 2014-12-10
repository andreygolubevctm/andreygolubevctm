<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="messageDao" class="com.ctm.dao.simples.MessageDao" scope="page" />

<c:set var="parentStatusId" value="${param.parentStatusId}" />

<%--
	This is rather dirty sorry. It should be using message_statuses.json, an Underscore template, and LESS.
--%>
<div class="radio">
	<c:forEach items="${messageDao.getStatuses(parentStatusId)}" var="status">

		<label style="display:inline-block; width:40%; margin-bottom:10px; margin-right:3%;">
			<input type="radio" name="status" value="<c:out value="${status.getId()}" />">
			<c:out value="${status.getStatus()}" />
		</label>

	</c:forEach>
</div>