<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:set var="h4Text" value="${normalHeading}"/>
<c:set var="pText" value="${normalCopy}"/>

<c:if test="${isFromExoticPage eq true}">
	<c:set var="h4Text" value="${exoticHeading}"/>
	<c:set var="pText" value="${exoticCopy}"/>
</c:if>

<ui:bubble variant="chatty" className="carHeadingBubbleContent">
	<h4>${h4Text}</h4>
	<p>${pText}</p>
</ui:bubble>