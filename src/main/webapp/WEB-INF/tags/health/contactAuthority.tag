<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Contact Authority"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}-selection" class="health_contact_authority">

	<c:set var="fieldXpath" value="${xpath}" />
	<form_new:row fieldXpath="${fieldXpath}" label='Do you want to be contacted by <span>Provider</span>?'>
		<field_new:array_radio items="Y=Yes,N=No" xpath="${fieldXpath}" title="if you wish to be contacted." required="true" className="${name}-contact-authority" id="${name}_contact-authority"/>
	</form_new:row>

</div>