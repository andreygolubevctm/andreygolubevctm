<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Builds the CSS to create a cross browser compatible opacity" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="value" required="true"	rtexprvalue="true"	 description="opacity value" %>

<%-- VARIABLES --%>
<c:set var="valuePercentage">${value*100}</c:set>

opacity: ${value}; /* Good browsers */
-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=${valuePercentage})"; /* IE 8 */
filter: alpha(opacity=${valuePercentage}); /* IE 5-7 */
-khtml-opacity: ${value}; /* Safari 1.x */
-moz-opacity: ${value}; /* FF */
zoom: 1; /* trick to trigger has-layout on old IEs */