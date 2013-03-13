<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's date of birth."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<%-- CSS --%>
<go:style marker="css-head">
	.dob_container span.fieldrow_legend {
		float:none;
	}
</go:style>

<%-- HTML --%>
<span class="dob_container">

	<input type="text" name="${name}" id="${name}" class="person_dob" value="${data[xpath]}" title="${title}" size="12">
	<span class="fieldrow_legend">Example: 14/06/1975</span>
</span>
<%-- JQUERY UI --%>
<go:script marker="jquery-ui">
	$("#${name}")
		.mask("99/99/9999",{placeholder: 'DD/MM/YYYY'})
		.blur(function(){
			$("#${name}_dp").val($(this).val());
		});
</go:script>

<%-- VALIDATION --%>
<fmt:setLocale value="en_GB"/>

<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<% now.add(java.util.GregorianCalendar.YEAR, -85); %>
<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="minDate" />

<%-- Unfortunately no easy way to add durations to dates in JSTL so have to resort to scriptlet :( --%>
<% now.add(java.util.GregorianCalendar.YEAR, 69); %>
<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="maxDate" />

<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title} date of birth"/>
<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="minDateEUR" parm="'${minDate}'" message="The ${title} age cannot be over 85"/>
<go:validate selector="${name}" rule="maxDateEUR" parm="'${maxDate}'" message="The ${title} age cannot be under 16"/>


