<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="A submit button for a form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="label" required="true" rtexprvalue="true" description="label text to display on button" %>

<%-- HTML --%>
<div onClick="submitForm()" id="mySubmit">${label}</div>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$("input:submit, #mySubmit").button();
</go:script>
