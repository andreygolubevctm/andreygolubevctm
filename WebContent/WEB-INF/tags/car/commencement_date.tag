<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Form for entry of policy commencement date"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 	required="true"	 rtexprvalue="true"	 description="base xpath for elements" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- PRELOAD HANDLING --%>
<c:if test="${not empty param.preload and param.preload eq 'true'}">
	<%
		java.text.DateFormat df = new java.text.SimpleDateFormat("dd/MM/yyyy");
		String formattedDate = df.format(new java.util.Date());
	%>
	<go:setData dataVar="data" xpath="${xpath}/options/commencementDate" value="<%=formattedDate %>" />
</c:if>

<%-- HTML --%>
<form_new:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
		<car:snapshot />
	</jsp:attribute>

	<jsp:body>
		<form_new:fieldset legend="Policy Start Date" id="${name}_options_commencementDateFieldSet">
			<form_new:row fieldXpath="${xpath}/options/commencementDate" label="When would you like to start your insurance?">
				<field_new:commencement_date xpath="${xpath}/options/commencementDate"	required="true" title="policy" days="30" />
			</form_new:row>
		</form_new:fieldset>
	</jsp:body>
</form_new:fieldset_columns>
