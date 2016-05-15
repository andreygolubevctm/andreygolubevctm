<%@ tag description="Fieldset - a collection of fields"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="legend"			required="true"		rtexprvalue="true"	description="text for the legend" %>
<%@ attribute name="id"				required="false" 	rtexprvalue="true"	description="id for the fieldset" %>
<%@ attribute name="helpId"			required="false" 	rtexprvalue="true"	description="id for a help bubble" %>
<%@ attribute name="showHelpText"	required="false" 	rtexprvalue="true"	description="Trigger to display help icon as text rather than icon" %>
<%@ attribute name="className"		required="false" 	rtexprvalue="true"	description="additional class" %>
<%@ attribute name="postLegend"    required="false"    rtexprvalue="true"  description="Text appears below the legend"%>

<c:if test="${empty legend and not empty helpId}">
	<c:set var="legend" value="&nbsp;" />
</c:if>

<%-- HTML --%>
<fieldset class="qe-window fieldset ${className}"<c:if test="${not empty id}"> id="${id}"</c:if>>


	<%--To handle :empty usage in css and to hide this when empty we do need it on one line--%>
	<div class="content">
		<c:if test="${not empty legend}">
			<div>
				<h2>${legend}<field_v2:help_icon helpId="${helpId}" showText="${showHelpText}" /></h2>
				<c:if test="${not empty postLegend}">
				<p class="legend">${postLegend}</p>
				</c:if>
			</div>
		</c:if>
		<jsp:doBody />
	</div>
</fieldset>