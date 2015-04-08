<%@ tag description="Authentication token for unique NXS views per provider" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="authToken" required="true" rtexprvalue="true" description="authToken from the url parameters" %>

<%-- Get reference to current journey xpath root --%>
<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<go:setData dataVar="data" xpath="${journeyVertical}/authToken" value="${authToken}" />

<field:hidden xpath="${journeyVertical}/authToken" defaultValue="${authToken}" />