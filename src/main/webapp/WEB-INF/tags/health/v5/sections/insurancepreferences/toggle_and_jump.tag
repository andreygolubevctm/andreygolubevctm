<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Menu at top of benefits grouping to toggle selections and jump to other section"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="type" required="true" rtexprvalue="true" description="Flag for Hospital or Extras" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="CSS class to be applied to the parent container" %>

<%-- VARIABLES --%>
<c:set var="fieldXpath" value="${xpath}/toggleAndJumpMenu" />
<c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />
<c:set var="jumpToLabel">
    <c:choose>
        <c:when test="${type eq 'Hospital'}">Extras</c:when>
        <c:otherwise>Hospital</c:otherwise>
    </c:choose>
</c:set>

<div id="${name}${type}-container" class="toggleAndJumpMenu ${fn:toLowerCase(type)}${' '}${className}">
	<div class="innertube clearfix">
		<span class="option untickAll">Untick all</span>
		<span class="option jumpTo">Jump to: <span>${jumpToLabel}</span></span>
	</div>
</div>