<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:if test="${not empty callCentreNumber}">
<ui:bubble variant="info">
	<h4>Do you need a hand?</h4>
	<p class="larger">
		Call <span class="noWrap callCentreNumber">${callCentreNumber}</span>
	</p>
	<p class="smaller">
		Our Australian based call centre hours are
	</p>
	<p class="smaller">
		<strong><form:scrape id='135'/></strong><%-- Get the Call Centre Hours from Scrapes Table HLT-832 --%>
	</p>
</ui:bubble>
</c:if>