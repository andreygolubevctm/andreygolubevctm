<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:getAuthenticated />

<%-- Check that the user can assimilate a person --%>
<c:choose>
	<c:when test="${fn:length(authenticatedData.array['login/security/branch_leader']) > 0}">
		<c:if test="${authenticatedData['login/security/branch_leader'] == 'Y'}">
			<core:login uid="${param.uid}" asim="${true}" />
		</c:if>		
	</c:when>
	<c:otherwise>
		The user does not have sufficient privileges.
	</c:otherwise>
</c:choose>