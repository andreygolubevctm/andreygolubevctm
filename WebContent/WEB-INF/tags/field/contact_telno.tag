<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a telephone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the input box" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false" rtexprvalue="true"	 description="id of the surround div" %>
<%@ attribute name="maxlength"	required="false" rtexprvalue="true"	 description="maxlength of the input" %>
<%@ attribute name="isLandline"	required="false" rtexprvalue="true"	 description="Flag to require number to be landline" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="id" value="${name}" />
<c:if test="${not empty maxlength}"><c:set var="maxlength">maxlength="${maxlength}"</c:set></c:if>
<c:set var="isLandline">
	<c:choose>
		<c:when test="${not empty isLandline}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<input type="text" name="${name}" id="${id}" class="contact_telno ${className}" value="${data[xpath]}" title="${title}" ${maxlength}>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	jQuery("#${name}").mask("9999999999",{placeholder:""});
</go:script>
<go:script marker="js-head">
var validateTelNo = function(value, element, param) {
	/**
	 * This validation will always pass but will strip out invalid characters
	 * from the string before moving onto the genuine validation tests.
	 */
	var tmpVal = String(value);
	
	if( value != '' ) {
		try {
			tmpVal = String( parseInt(String(value), 10) );
		} catch(e) {
			// ignore and move on son
		}
		
		if( String(value).indexOf("0") == 0 && tmpVal.length ) {
			tmpVal = "0" + tmpVal;
		}
		
		if( tmpVal.length != 10 ) {
			tmpVal = "";
		}
	
		$(element).val( tmpVal );
	}
	
	return true;
};

$.validator.addMethod('trimExcessZeros', function(value, element, param) {
	return validateTelNo(value, element, param);
});

$.validator.addMethod('confirmLandline', function(value, element, param) {
	var valid = false;
	
	if( value != '' ) {
		if( String(value).length == 10 && String(value).indexOf("04") != 0 ) {
			valid = true;
		}
	}	
<c:if test="${not required}">
	else {
		valid = true;
	}
</c:if>
	
	return valid;
});
</go:script>
<go:script marker="onready">
$('#${name}').on("blur update", function(){
	validateTelNo($(this).val(), $(this));
});
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter ${title}" />
<c:if test="${isLandline eq true}">
	<go:validate selector="${name}" rule="confirmLandline" parm="true" message="${title} must be a landline"/>
</c:if>
<go:validate selector="${name}" rule="trimExcessZeros" parm="true" message="No message required - always passes"/>
