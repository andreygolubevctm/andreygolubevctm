<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a date."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<%-- CSS --%>
<go:style marker="css-head">
	.dob_container span.fieldrow_legend {
		float:none;
	}
</go:style>

<%-- HTML --%>
<span class="dob_container">

	<input type="text" name="${name}" id="${name}" class="person_dob" value="${value}" title="The ${title} date" size="12">
	<span class="fieldrow_legend">Example: 01/06/1975</span>
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
<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<% now.add(java.util.GregorianCalendar.YEAR, 0); %>
<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="maxDate" />

<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title} date"/>
<go:validate selector="${name}" rule="dateEUR" parm="true" message="Please enter a valid date in DD/MM/YYYY format"/>
<go:validate selector="${name}" rule="maxDateEUR" parm="'${maxDate}'" message="The ${title} date cannot be in the future"/>


