<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="action" 		required="true" rtexprvalue="true"	description="Action to submit the form to"%>
<%@ attribute name="method"	 		required="true" rtexprvalue="true"	description="Method to use when submitting"%>
<%@ attribute name="id" 			required="true" rtexprvalue="true"	description="The form's id"%>
<%@ attribute name="name" 			required="true" rtexprvalue="true"	description="The form's name"%>
<%@ attribute name="autoComplete" 	required="false" rtexprvalue="true"	description="Can override the autocomplete off setting of this tag"%>
<%@ attribute name="target" 		required="false" rtexprvalue="true"	description="If you want the target to be different for action submit"%>

<c:if test="${empty errorContainer}">
	<c:set var="errorContainer" value="slideErrorContainer" />
</c:if>
<%-- VARIABLES --%>
<c:if test="${method==''}">
	<c:set var="method" value="POST" />
</c:if>

<c:if test="${empty autoComplete}">
	<c:set var="autoComplete" value="off" />
</c:if>

<c:if test="${empty target}">
	<c:set var="target" value="_self" />
</c:if>

<%-- HTML --%>
<jsp:element name="form">
	<jsp:attribute name="id">${id}</jsp:attribute>
	<jsp:attribute name="name">${name}</jsp:attribute>	
	<jsp:attribute name="method">${method}</jsp:attribute>
	<jsp:attribute name="action">${action}</jsp:attribute>
	<jsp:attribute name="autocomplete">${autoComplete}</jsp:attribute>
	<jsp:attribute name="target">${target}</jsp:attribute>
	<jsp:body>
		<jsp:doBody />
		<input type="hidden" name="transcheck" id="transcheck" value="1" />
	</jsp:body>
</jsp:element>

<%-- EXTERNAL JAVASCRIPTS --%>
<go:script marker="js-href"	href="common/js/jquery.maskedinput-1.3-co.min.js"/>
<go:script marker="js-href"	href="common/js/jquery.metadata.js"/>

<go:script marker="js-href"	href="common/js/jquery.bgiframe.js"/>