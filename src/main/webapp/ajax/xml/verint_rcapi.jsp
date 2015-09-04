<%@ page language="java" contentType="text/xml; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<session:getAuthenticated  />

<%
	response.setContentType("text/plain");
	response.setCharacterEncoding("UTF-8");
%>

<%-- Store flag as to whether Simples Operator or Other and protect page --%>
<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>


<c:if test="${empty authenticatedData.login.user.agentId or authenticatedData.login.user.agentId eq ''}">
	<%
		response.setStatus(412);
		response.getWriter().write("Parameter preconditions failed, no AgentId");
		if(true) return; 
	%>
</c:if>


<c:set var="action"><c:out value="${param.action}" escapeXml="true" /></c:set>

${logger.debug('Started verint action. {}', log:kv('action', action))}

<c:choose>
	<c:when test="${empty isOperator}">
		<%
		if(!response.isCommitted()) {
			response.setStatus(401);
			response.getWriter().write("This page is protected.");
		}
		%>
	</c:when>
	<c:when test="${action != 'PauseRecord' and action != 'ResumeRecord'}">
		<%
		if(!response.isCommitted()) {
			response.setStatus(412);
			response.getWriter().write("Parameter preconditions failed");
		}
		%>
	</c:when>
	<c:otherwise>
		<core:verint_rcapi_mute contentType="Audio" action="${action}" agentId="${authenticatedData.login.user.agentId}" />
	</c:otherwise>
</c:choose>