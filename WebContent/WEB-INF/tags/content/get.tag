<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="key" required="true" rtexprvalue="true"  %>
<%@ attribute name="suppKey" required="false" rtexprvalue="true"  %>

<session:core />

<c:choose>
	<c:when test="${empty suppKey}">
		${contentService.getContentValue(pageContext.getRequest(), key)}
	</c:when>
	<c:otherwise>
		${contentService.getContentWithSupplementary(pageContext.getRequest(), key).getSupplementaryValueByKey(suppKey)}
	</c:otherwise>
</c:choose>
