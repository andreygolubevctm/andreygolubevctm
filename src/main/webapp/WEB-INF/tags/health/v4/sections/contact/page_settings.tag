<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Settings for the contact page"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- VARIABLES --%>
<c:set var="val_optin"				value="Y" />
<c:set var="val_optout"				value="N" />

<%-- Name is mandatory for both online and callcentre, other fields only mandatory for online --%>
<c:set var="required" value="${true}" />
<c:if test="${callCentre}">
	<c:set var="required" value="${false}" />
</c:if>
