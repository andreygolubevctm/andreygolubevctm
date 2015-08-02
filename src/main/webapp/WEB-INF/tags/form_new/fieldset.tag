<%@ tag description="Fieldset - a collection of fields"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="legend"			required="true"		rtexprvalue="true"	description="text for the legend" %>
<%@ attribute name="id"				required="false" 	rtexprvalue="true"	description="id for the fieldset" %>
<%@ attribute name="helpId"			required="false" 	rtexprvalue="true"	description="id for a help bubble" %>
<%@ attribute name="showHelpText"	required="false" 	rtexprvalue="true"	description="Trigger to display help icon as text rather than icon" %>
<%@ attribute name="className"		required="false" 	rtexprvalue="true"	description="additional class" %>

<c:if test="${empty legend and not empty helpId}">
	<c:set var="legend" value="&nbsp;" />
</c:if>

<%-- HTML --%>
<fieldset class="qe-window fieldset ${className}"<c:if test="${not empty id}"> id="${id}"</c:if>>
	<c:if test="${not empty legend}">
		<div><h2>${legend}<field_new:help_icon helpId="${helpId}" showText="${showHelpText}" /></h2></div>
	</c:if>

	<div class="content">
		<jsp:doBody />
	</div>
</fieldset>