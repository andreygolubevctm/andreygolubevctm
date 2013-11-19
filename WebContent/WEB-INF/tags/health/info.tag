<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Simple text relay with additional mark-ups"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="true"		rtexprvalue="false"  description="This is the same as the Help ID attribute" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="icon" 		required="false" 	rtexprvalue="true"	 description="Suppress the icon with false" %>

<c:import url="ajax/xml/help.jsp" var="XMLdoc">
	<c:param name="id" value="${id}" />
</c:import>

<x:parse doc="${XMLdoc}" var="XMLdata" />

<%-- HTML --%>
<div class="health-info ${className}">
	<c:if test="${empty icon || icon != false || icon != 'false'}"><span class="health-info-icon"></span></c:if>
	<div class="health-info-text"><x:out select="$XMLdata//help" /></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
.health-info {
	position:relative !important;
	width:100% !important;
	clear:both !important;
}
</go:style>