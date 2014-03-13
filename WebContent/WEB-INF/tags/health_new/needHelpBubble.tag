<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<ui:bubble variant="info">
	<h4>Need some help?</h4>
	<p class="larger">
		Call 1800 77 77 12
	</p>
	<p class="smaller">
		Our Australian based call centre hours are
	</p>
	<p class="smaller">
		<strong><form:scrape id='135'/></strong><%-- Get the Call Centre Hours from Scrapes Table HLT-832 --%>
	</p>
</ui:bubble>