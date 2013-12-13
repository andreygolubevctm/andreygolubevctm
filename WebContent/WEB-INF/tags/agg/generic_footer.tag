<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="scrapeId" required="false"	rtexprvalue="true"	description="id for scapes table defaults to 133" %>
<%@ attribute name="includeCopyRight" required="false"	rtexprvalue="true"	description="boolean to display the ctm copyright notice defaults to true" %>

<c:if test="${empty includeCopyRight}">
	<c:set var="includeCopyRight" value="${true}" />
</c:if>

<c:if test="${empty scrapeId}">
	<c:set var="scrapeId" value="133" />
</c:if>

<%-- HTML --%>
<agg:footer_outer includeCopyRight="${includeCopyRight}">
	<form:scrape id="${scrapeId}" />
</agg:footer_outer>