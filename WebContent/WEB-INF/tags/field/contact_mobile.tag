<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a mobile phone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="dummyname" value="${name}input" />

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" class="" value="${data[xpath]}">
<input type="text" name="${dummyname}" id="${dummyname}" class="contact_telno ${className}" value="${data[xpath]}" title="The mobile phone number">

<%-- VALIDATION --%>
<go:validate selector="${dummyname}" rule="validateMobile" parm="true" message="Please enter a valid mobile phone number" />
<go:validate selector="${dummyname}" rule="required" parm="${required}" message="Please enter the mobile phone number" />

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	jQuery("#${dummyname}").mask("(9999) 999 999",{placeholder:"_"});
</go:script>
<go:script marker="js-head">


$.validator.addMethod("validateMobile",
	function(value, element) {
		if( !value.length ) {
			return true;
		} else if ( value.indexOf("0") != 1 ) {
			return false;
		} else {
			return true;
		}
	}
);
</go:script>
		
<go:script marker="onready">
	$("#${dummyname}").on("focus blur", function(){
		$("#${name}").val( String($("#${dummyname}").val()).replace(/[^0-9]/g, '') ); 
	});
	
	// As a safety net for existing values - force update
	$("#${name}").val( String($("#${dummyname}").val()).replace(/[^0-9]/g, '') );
</go:script>