<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="messageOverviewDao" class="com.ctm.dao.MessageOverviewDao" scope="page" />

<settings:setVertical verticalCode="SIMPLES" />

<%@ include file="/WEB-INF/security/core.jsp" %>

<layout:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

	<jsp:body>

		<c:choose>
			<c:when test="${!isRoleSupervisor}">
				<div class="alert alert-danger">You are not authorised to view this page ('supervisor' only).</div>
			</c:when>
			<c:otherwise>

<h2>Message Queue Overview</h2>

<c:set var="overview" value="${ messageOverviewDao.getMessageOverview() }" />

<div class="simples-report">
	<table class="table">
		<tbody>
			<tr>
				<th width="20%">Current messages:</th>
				<td><c:out value="${overview.getCurrent()}" /></td>

				<th width="20%">Pending:</th>
				<td><c:out value="${overview.getPending()}" /></td>
			</tr>
			<tr>
				<th>Future messages:</th>
				<td><c:out value="${overview.getFuture()}" /></td>

				<th>Postponed:</th>
				<td><c:out value="${overview.getPostponed()}" /></td>
			</tr>
			<tr>
				<td></td>
				<td></td>

				<th>Completed:</th>
				<td><c:out value="${overview.getCompleted()}" /></td>
			</tr>
			<tr>
				<td></td>
				<td></td>

				<th>Expired:</th>
				<td><c:out value="${overview.getExpired()}" /></td>
			</tr>
		</tbody>
	</table>
</div>

			</c:otherwise>
		</c:choose>

	</jsp:body>
</layout:simples_page>
