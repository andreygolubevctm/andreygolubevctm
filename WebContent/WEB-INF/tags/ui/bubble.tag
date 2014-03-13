<%@ tag description="Bubble is a panel of information or marketing. The variants inherit off the Bootstrap well component." %>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="variant" required="false" rtexprvalue="true" description="Style variant: help, info, chatty" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Additional class names" %>

<c:if test="${not empty variant}">
	<c:set var="classes" value=" well-${variant}" />
</c:if>

<c:if test="${not empty className}">
	<c:set var="className" value=" ${className}" />
</c:if>


<%-- HTML --%>
<div class="well${classes}${className}">
	<jsp:doBody />
</div>
