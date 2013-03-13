<%@ tag trimDirectiveWhitespaces="true" %>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Generates the user IP address."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Pull out the IP Address --%>
<c:set var="ip" value="${pageContext.request.remoteAddr}" />

<c:out value="${ip}" />