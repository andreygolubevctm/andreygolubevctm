<%@ tag description="Fieldset - a collection of fields"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="legend"		required="true"		rtexprvalue="true"	description="text for the legend" %>
<%@ attribute name="id"			required="false" 	rtexprvalue="true"	description="id for the fieldset" %>
<%@ attribute name="helpId"			required="false" 	rtexprvalue="true"	description="id for a help bubble" %>
<%@ attribute name="className"	required="false" 	rtexprvalue="true"	description="additional class" %>

<c:if test="${ empty(id) }">
	<c:set var="id">xfr_<%= java.lang.Math.round(java.lang.Math.random() * 32768) %></c:set>
</c:if>

<%-- HTML --%>
<div class="qe-window fieldset ${className}" id="${id}">
	<h4>${legend}
	<c:if test="${helpId != null && helpId != ''}">
		<span class="help_icon" id="help_${helpId}"></span>
	</c:if>

	</h4>
	<div class="content">
		<jsp:doBody />
	</div>
	<div class="footer"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	h4 .help_icon { float: right; margin: 0px 6px; }
	.qe-window h4 .help_icon { position:absolute; right:6px; }
</go:style>