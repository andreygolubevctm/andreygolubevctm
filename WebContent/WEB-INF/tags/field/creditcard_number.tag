<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="creditcardnumber" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<%-- HTML --%>
<input type="text" name="${creditcardnumber}" id="${creditcardnumber}" class="creditcard_number ${className}" value="${value}" size="21"/>

<%-- VALIDATION --%>
<go:validate selector="${creditcardnumber}" rule="ccNumber" parm="${required}" message="Please enter a valid ${title}"/>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

	$.validator.addMethod("ccNumber",
			function(value, elem, parm) {

				<%-- Strip non-numeric --%>
				value = value.replace(/[^0-9]/g, '');

				if(value.length == 16){
					return true;
				}else{
					return false;
				}
			},
			""
	);

</go:script>


<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	$(':input[name=${creditcardnumber}]').mask("9999 9999 9999 9999")
</go:script>