<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Builds the CSS to create a cross browser compatible rounded corners" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="value" required="true"	rtexprvalue="true"	 description="rounding value" %>
<%@ attribute name="corners" required="false"	rtexprvalue="true"	 description="which corners should be rounded" %>
<%-- @todo be able to have different values for the different cornders: topleft, topright, bottomleft, bottomright --%>
<%-- @todo add ability to have elliptical rounding (different horizontal and vertical values for a corner) --%>

<c:choose>
	<c:when test="${empty corners}">
		-moz-border-radius: ${value}px;
		-webkit-border-radius: ${value}px;
		border-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'top'}">
		border-top-right-radius: ${value}px;
		border-top-left-radius: ${value}px;
		-moz-border-radius-topleft: ${value}px;
		-moz-border-radius-topright: ${value}px;
		-webkit-border-top-right-radius: ${value}px;
		-webkit-border-top-left-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'bottom'}">
		border-bottom-right-radius: ${value}px;
		border-bottom-left-radius: ${value}px;
		-moz-border-radius-bottomright: ${value}px;
		-moz-border-radius-bottomleft: ${value}px;
		-webkit-border-bottom-right-radius: ${value}px;
		-webkit-border-bottom-left-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'left'}">
		border-top-left-radius: ${value}px;
		border-bottom-left-radius: ${value}px;
		
		-moz-border-radius-topleft: ${value}px;
		-moz-border-radius-bottomleft: ${value}px;
		
		-webkit-border-top-left-radius: ${value}px;
		-webkit-border-bottom-left-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'right'}">
		border-top-right-radius: ${value}px;
		border-bottom-right-radius: ${value}px;
		
		-moz-border-radius-topright: ${value}px;
		-moz-border-radius-bottomright: ${value}px;
		
		-webkit-border-top-right-radius: ${value}px;
		-webkit-border-bottom-right-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'topleft'}">
		border-top-left-radius: ${value}px;
		-moz-border-radius-topleft: ${value}px;
		-webkit-border-top-left-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'topright'}">
		border-top-right-radius: ${value}px;
		-moz-border-radius-topright: ${value}px;
		-webkit-border-top-right-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'bottomleft'}">
		border-bottom-left-radius: ${value}px;
		-moz-border-radius-bottomleft: ${value}px;
		-webkit-border-bottom-left-radius: ${value}px;
	</c:when>
	<c:when test="${corners eq 'bottomright'}">
		border-bottom-right-radius: ${value}px;
		-moz-border-radius-bottomright: ${value}px;
		-webkit-border-bottom-right-radius: ${value}px;
	</c:when>
	<c:otherwise>
	</c:otherwise>
</c:choose>