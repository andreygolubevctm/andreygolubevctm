<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>
<c:set var="callCentreAppNumber" scope="request"><content:get key="callCentreAppNumber"/></c:set>

<div class="sidebar-box callCentreHelp">
	<div class="default-content">
		<h4>We can help you</h4>
		<p>Not sure? Call <span class="noWrap callCentreNumber">${callCentreNumber}</span><span class="noWrap callCentreAppNumber">${callCentreAppNumber}</span> and one of our health insurance experts can help you make sense of it all.</p>
	</div>
	<div class="custom-content">
		<div class="dynamic"></div>
		<p>Call us on <span class="noWrap callCentreNumber">${callCentreNumber}</span><span class="noWrap callCentreAppNumber">${callCentreAppNumber}</span></p>
	</div>
</div>