<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's age."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The input field's title"%>
<%@ attribute name="maxlength" 	required="false" rtexprvalue="true"	 description="The maximum length for the input field"%>
<%@ attribute name="validationNoun"	required="true"	 rtexprvalue="true"	 description="Validation of who we're age checking for. ie: traveller"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${not empty validationNoun}">
	<c:set var="validationNoun" value=" ${validationNoun}" />
</c:if>

<%-- HTML --%>
<field_new:input type="text" xpath="${xpath}" className="${className}" maxlength="${maxlength}" required="false" title="${title}" pattern="[0-9]*" />

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="ageRange" parm="true" message="Please enter the age of the oldest Adult${validationNoun}. Adult${validationNoun}s must be aged 16 - 99."/>
	<go:validate selector="${name}" rule="numericOnly" parm="true" />
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
		"Adult${validationNoun}s must be aged 16 - 99."
	);
</go:script>