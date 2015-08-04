<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds the CSS to create a cross browser compatible box shadow" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="horizontalOffset"	 	required="false"	rtexprvalue="true"	 description="horizontal offset value in pixels" %>
<%@ attribute name="verticalOffset" 		required="false"	rtexprvalue="true"	 description="vertical offset value in pixels" %>
<%@ attribute name="blurRadius"				required="false"	rtexprvalue="true"	 description="blur radius value in pixels" %>
<%@ attribute name="spread"					required="false"	rtexprvalue="true"	 description="spread value in pixels" %>
<%@ attribute name="color"					required="true"		rtexprvalue="true"	 description="color of the shadow (in hex or rgb or rgba value)" %>
<%@ attribute name="inset" 					required="false"	rtexprvalue="true"	 description="whether to display the shadow inside or not" %>

<%-- VARIABLES --%>
<c:if test="${empty horizontalOffset}"><c:set var="horizontalOffset" value="0" /></c:if>
<c:if test="${empty verticalOffset}"><c:set var="verticalOffset" value="0" /></c:if>
<c:if test="${empty blurRadius}"><c:set var="blurRadius" value="0" /></c:if>
<c:if test="${empty spread}"><c:set var="spread" value="0" /></c:if>
<c:if test="${inset == true}"><c:set var="inset" value=" inset" /></c:if>

<%-- if rgb color --%>
<c:if test="${fn:contains(color, ',')}">
	<c:set var="numberOfValues">${fn:length(fn:split(color, ","))}</c:set>
	<c:choose>
		<%-- if rgb color --%>
		<c:when test="${numberOfValues == 3}">
			<c:set var="color">rgba(${color},1)</c:set>
		</c:when>
		<%-- if rgba color --%>
		<c:when test="${numberOfValues == 4}">
			<c:set var="color">rgba(${color})</c:set>
		</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:if>

-moz-box-shadow: ${horizontalOffset}px ${verticalOffset}px ${blurRadius}px ${spread}px ${color} ${inset};
-webkit-box-shadow: ${horizontalOffset}px ${verticalOffset}px ${blurRadius}px ${spread}px ${color} ${inset};
box-shadow: ${horizontalOffset}px ${verticalOffset}px ${blurRadius}px ${spread}px ${color} ${inset};

<%-- @todo generate the code for IE<9 but good luck as this seems very complicated --%>
<%-- good start: http://www.useragentman.com/blog/2011/08/24/how-to-simulate-css3-box-shadow-in-ie7-8-without-javascript/ --%>