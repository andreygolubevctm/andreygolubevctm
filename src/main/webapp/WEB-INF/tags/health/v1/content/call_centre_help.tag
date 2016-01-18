<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="callCentreNumber" scope="request"><content:get key="callCentreNumber"/></c:set>

<c:if test="${not empty callCentreNumber}">
	<div class="sidebar-box callCentreHelp">
		<h4>We can help you</h4>
		<p>Not sure? Call <span class="noWrap callCentreNumber">${callCentreNumber}</span> and one of our health insurance experts can help you make sense of it all.</p>
	</div>
</c:if>