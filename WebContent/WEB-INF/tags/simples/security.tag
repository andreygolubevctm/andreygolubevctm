<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Performs a basic user security test on a security keyword and returns either true/false"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="key" 	required="true"	 rtexprvalue="true" description="The key value to check for in the security tag" %>

<%-- VARIABLES --%>
<c:set var="result" value="${false}" />
<c:set var="path" value="login/security/${key}" />


<c:if test="${fn:length(data.array[path]) > 0}">
	<c:if test="${data[path] == 'Y' || data[path] == 'true'}">
		<c:set var="result" value="${true}" />
	</c:if>
</c:if>

${result}