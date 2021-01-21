<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Menu at top of benefits grouping to toggle selections and jump to other section"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>
<%@ attribute name="type" required="true" rtexprvalue="true" description="Flag for Hospital or Extras" %>

<%-- VARIABLES --%>
<c:set var="fieldXpath" value="${xpath}/benefitsLoadingAnimation" />
<c:set var="name" value="${go:nameFromXpath(fieldXpath)}" />

<div id="${name}${type}_Loader" class="benefitsLoadingAnimation ${fn:toLowerCase(type)}">
    <div class="health-icon icon-health-loading-spinner spinner"><!-- empty --></div>
</div>