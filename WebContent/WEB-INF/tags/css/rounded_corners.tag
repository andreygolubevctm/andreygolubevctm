<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds the CSS to create a cross browser compatible rounded corners" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="value" required="true"	rtexprvalue="true"	 description="rounding value" %>
<%@ attribute name="corners" required="false"	rtexprvalue="true"	 description="which corners should be rounded eg top-left, top-right" %>
<%-- @todo be able to have different values for the different corners: topleft, topright, bottomleft, bottomright --%>
<%-- @todo add ability to have elliptical rounding (different horizontal and vertical values for a corner) --%>

<c:if test="${not empty corners}">
	<c:set var="corners" value="${fn:split(corners, ',')}" />
</c:if>
<c:choose>
	<c:when test="${empty corners}">
		-moz-border-radius: ${value}px;
		-webkit-border-radius: ${value}px;
		border-radius: ${value}px;
	</c:when>
	<c:otherwise>
		<c:forEach var="corner" items="${corners}">
			<c:set var="corner" value="${fn:split(corner, '-')}" />
			<c:choose>
				<c:when test="${fn:length(corner) > 1}">
					border-${corner[0]}-${corner[1]}-radius: ${value}px;
					-moz-border-radius-${corner[0]}${corner[1]}: ${value}px;
					-webkit-border-${corner[0]}-${corner[1]}-radius: ${value}px;
				</c:when>
				<c:otherwise>
					border-${corner[0]}-radius: ${value}px;
					-moz-border-radius-${corner[0]}: ${value}px;
					-webkit-border-${corner[0]}-radius: ${value}px;
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</c:otherwise>
</c:choose>