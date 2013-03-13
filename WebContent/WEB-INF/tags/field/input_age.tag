<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's age."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The input field's title"%>
<%@ attribute name="maxlength" 	required="false" rtexprvalue="true"	 description="The maximum length for the input field"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="${className}" value="${data[xpath]}" maxlength="${maxlength}">


<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="ageRange" parm="true" message="Age is not allowed."/>
	<go:validate selector="${name}" rule="onkeyup" parm="false" message=" "/>

</c:if>

<go:script marker="onready">
	// Validate age range 16-99
	$.validator.addMethod("ageRange",
		function(value, element){
			if(parseInt(value) >= 16 && parseInt(value) < 100){
				return true;
			}
		},
		"Adult travellers must be aged 16 - 99."
	);
</go:script>