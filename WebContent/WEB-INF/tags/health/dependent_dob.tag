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

	<input type="text" name="${name}" id="${name}" class="person_dob" value="${data[xpath]}" title="The dependant's date of birth" size="12">
	<span class="fieldrow_legend">Example: 27/09/1998</span>
</span>
<%-- JQUERY UI --%>
<go:script marker="jquery-ui">
	$("#${name}")
		.mask("99/99/9999",{placeholder: 'DD/MM/YYYY'})
		.blur(function(){
			$("#${name}_dp").val($(this).val());
		});
</go:script>



<%-- VALIDATION  for max date --%>
<fmt:setLocale value="en_GB"/>
<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<%-- Unfortunately no easy way to add durations to dates in JSTL so have to resort to scriptlet :( --%>
<% now.add(java.util.GregorianCalendar.YEAR, 0); %>
<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="maxDate" />

<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the dependant's date of birth"/>
<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="maxDateEUR" parm="'${maxDate}'" message="The dependant's age cannot be under 0"/>
<%-- NOTE: the below can be dynamically altered using an age value the dependants tag --%>
<go:validate selector="${name}" rule="limitDependentAgeToUnder25" parm="true" message='Your child cannot be added to the policy as they are aged 25 years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance.' />