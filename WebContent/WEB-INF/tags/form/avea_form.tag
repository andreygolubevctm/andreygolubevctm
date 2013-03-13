<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="action" required="true" rtexprvalue="false"	description="Action to submit the form to"%>
<%@ attribute name="method" required="true" rtexprvalue="false"	description="Method to use when submitting"%>
<%@ attribute name="id" 	required="true" rtexprvalue="false"	description="The form's id"%>
<%@ attribute name="name" 	required="true" rtexprvalue="false"	description="The form's name"%>

<%-- VARIABLES --%>
<c:if test="${method==''}">
	<c:set var="method" value="POST" />
</c:if>

<%-- HTML --%>
<jsp:element name="form">
	<jsp:attribute name="id">${id}</jsp:attribute>
	<jsp:attribute name="name">${name}</jsp:attribute>	
	<jsp:attribute name="method">${method}</jsp:attribute>
	<jsp:attribute name="action">${action}</jsp:attribute>
	<jsp:attribute name="autocomplete">off</jsp:attribute>
	<jsp:body>
		<jsp:doBody />
	</jsp:body>
</jsp:element>

<%-- EXTERNAL JAVASCRIPTS --%>
<go:script marker="js-href"	href="common/js/jquery.maskedinput-1.2.2-co.min.js"/>
<go:script marker="js-href"	href="common/js/jquery.metadata.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.pack-1.7.0-bubble.js"/>
<go:script marker="js-href"	href="common/js/jquery.validate.custom.js"/>

<go:script marker="onready">
	$('.shelp_hover').tooltip({
		track: true, 
	    delay: 0, 
	    showURL: false, 
	    showBody: " - ", 
	    fade: 250 
	});	
	$('.help_hover').tooltip({
    	delay: 100, 
    	fade: 300,
    	showURL: false,
    	top: -25,
    	left: 'auto',
    	bodyHandler: function() { 
	        return $(this).next().html(); 
    	},
    	extraClass: "help_text ui-widget ui-dialog ui-corner-all ui-widget-content" 
	});
</go:script>

