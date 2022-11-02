<%@ tag description="Inpiut" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Get reference to current journey xpath root --%>
<c:set var="journeyVertical" value="${pageSettings.getVerticalCode()}" />
<c:if test="${journeyVertical eq 'car'}">
	<c:set var="journeyVertical" value="quote" />
</c:if>

<%-- If gaClientId already exists then render as hidden input --%>
<c:set var="fieldXpath" value="${journeyVertical}/gaclientid" />
<c:if test="${not empty data[fieldXpath]}">
	<field_v1:hidden xpath="${fieldXpath}" />
</c:if>

<%-- If anonIdGa already exists then render as hidden input --%>
<c:set var="fieldXpath" value="${journeyVertical}/anonIdGa" />
<c:if test="${not empty data[fieldXpath]}">
	<field_v1:hidden xpath="${fieldXpath}" />
</c:if>