<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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

<simples:template_consultantstatus />

<h2>Consultant Call Status</h2>

<div data-provide="simples-consultant-status">
	<%--
	TODO Hook up to simplesUserStatus module
	--%>
	<button type="button" class="btn btn-cta simples-status-refresh" disabled>Refresh</button>

	<div class="simples-status">
		<!-- simples-template-consultantstatus inserted here -->
	</div>
</div>

			</c:otherwise>
		</c:choose>

	</jsp:body>
</layout:simples_page>
