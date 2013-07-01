<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Builds the CSS to create a cross browser compatible gradient" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="topColor"			required="true"	rtexprvalue="true"	 description="top color of the gradient on the button" %>
<%@ attribute name="topColorAlpha"		required="false"	rtexprvalue="true"	 description="top color of the gradient's alpha transparency (0 to 1)" %>
<%@ attribute name="bottomColor"		required="true"	rtexprvalue="true"	 description="bottom color of the gradient on the button" %>
<%@ attribute name="bottomColorAlpha"	required="false"	rtexprvalue="true"	 description="bottom color of the gradient's alpha transparency (0 to 1)" %>

<%-- VARIABLES --%>
<c:if test="${empty topColorAlpha}"><c:set var="topColorAlpha" value="1" /></c:if>
<c:if test="${empty bottomColorAlpha}"><c:set var="bottomColorAlpha" value="1" /></c:if>

<%-- transform bottom hexa color into RGB and RGBA values --%>
<c:set var="rgbBottomColor"><css:hex_to_rgb hexValue="${bottomColor}"/></c:set>
<c:set var="rgbaBottomColor">${rgbBottomColor},${bottomColorAlpha}</c:set>

<%-- transform top hexa color into RGB and RGBA values --%>
<c:set var="rgbTopColor"><css:hex_to_rgb hexValue="${topColor}"/></c:set>
<c:set var="rgbaTopColor">${rgbTopColor},${topColorAlpha}</c:set>

<%-- From HEXA to SVG transform --%>
<c:set var="xmlSvgGradient">
	<?xml version="1.0" ?>
	<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 1 1" preserveAspectRatio="none">
		<linearGradient id="button-gradient" gradientUnits="userSpaceOnUse" x1="0%" y1="0%" x2="0%" y2="100%">
			<stop offset="0%" stop-color="${topColor}" stop-opacity="${topColorAlpha}"/>
			<stop offset="100%" stop-color="${bottomColor}" stop-opacity="${bottomColorAlpha}"/>
		</linearGradient>
		<rect x="0" y="0" width="1" height="1" fill="url(#button-gradient)" />
	</svg>
</c:set>
<c:set var="base64SvgGradient">${go:base64Encode(xmlSvgGradient)}</c:set>

<%-- ALPHA VALUES TO HEX --%>
<c:set var="topColorAlphaHexTemp"><fmt:formatNumber value="${topColorAlpha*255}" maxFractionDigits="0" /></c:set>
<c:set var="topColorAlphaHex"><css:rgb_to_hex rgbValue="${topColorAlphaHexTemp}" /></c:set>

<c:set var="bottomColorAlphaHexTemp"><fmt:formatNumber value="${bottomColorAlpha*255}" maxFractionDigits="0" /></c:set>
<c:set var="bottomColorAlphaHex"><css:rgb_to_hex rgbValue="${bottomColorAlphaHexTemp}" /></c:set>

background-color: ${bottomColor}; /* Old browsers */
background: ${bottomColor}; /* Old browsers */
background: url(data:image/svg+xml;base64,${base64SvgGradient}); /* IE9 SVG, needs conditional override of 'filter' to 'none' */
background: -moz-linear-gradient(top,  rgba(${rgbaTopColor}) 0%, rgba(${rgbaBottomColor}) 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(${rgbaTopColor})), color-stop(100%,rgba(${rgbaBottomColor}))); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  rgba(${rgbaTopColor}) 0%,rgba(${rgbaBottomColor}) 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  rgba(${rgbaTopColor}) 0%,rgba(${rgbaBottomColor}) 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  rgba(${rgbaTopColor}) 0%,rgba(${rgbaBottomColor}) 100%); /* IE10+ */
background: linear-gradient(to bottom,  rgba(${rgbaTopColor}) 0%,rgba(${rgbaBottomColor}) 100%); /* W3C */
<%-- add transparency to Hex colors for IE --%>
<c:set var="topColor">#${topColorAlphaHex}${fn:replace(topColor, "#", "")}</c:set>
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='${topColor}', endColorstr='${bottomColor}',GradientType=0 ); /* IE6-9 */