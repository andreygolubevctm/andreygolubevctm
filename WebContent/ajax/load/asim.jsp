<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- Check that the user can assimilate a person --%>
<c:choose>
	<c:when test="${fn:length(data.array['login/security/branch_leader']) > 0}">
		<c:if test="${data['login/security/branch_leader'] == 'Y'}">
			<core:login uid="${param.uid}" asim="${true}" />
		</c:if>		
	</c:when>
	<c:otherwise>
		The user does not have sufficient privileges.
	</c:otherwise>
</c:choose>