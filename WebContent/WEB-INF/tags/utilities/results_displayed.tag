<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Results Displayed group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Results Displayed">
		
		<form:row label="Show me results for">
			<field:array_select items="All=All,GP=Only Green Plans,NC=No Contract" xpath="${xpath}/resultsFor" title="show results for" required="true" />
		</form:row>
		
		<form:row label="Your email address">
			<field:contact_email xpath="${xpath}/email" required="false" title="your email address" />
		</form:row>
	</form:fieldset>		

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name}{
		zoom: 1;
	}
</go:style>


<%-- JAVASCRIPT --%>


<%-- VALIDATION --%>
