<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Performs a basic user security test on a security keyword and returns either true/false"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('/simples/security.tag')}" />

<%-- ATTRIBUTES --%>
<%@ attribute name="key" 	required="true"	 rtexprvalue="true" description="The key value to check for in the security tag" %>

<%-- VARIABLES --%>
<c:set var="result" value="${false}" />
<c:set var="path" value="login/security/${key}" />


<c:if test="${fn:length(authenticatedData.array[path]) > 0}">
	<c:if test="${authenticatedData[path] == 'Y' || authenticatedData[path] == 'true'}">
		<c:set var="result" value="${true}" />
	</c:if>
</c:if>

${logger.info('Got result. {},{}', log:kv('key', key), log:kv('result', result))}
<c:out value="${result}" />