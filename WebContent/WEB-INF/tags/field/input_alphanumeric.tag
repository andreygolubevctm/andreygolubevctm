<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a text input of only Alpha-numeric Characters"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The input field's title"%>
<%@ attribute name="maxlength" 	required="false" rtexprvalue="true"	 description="The maximum length for the input field"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="${className}" value="${value}" maxlength="${maxlength}">

<%-- VALIDATION --%>
<c:if test="${required}">
	<go:validate selector="${name}" rule="required" parm="true" message="Please enter the ${title}"/>
	<go:validate selector="${name}" rule="alphanum" parm="true" message="Please enter a valid ${title}"/>
</c:if>


<%-- JQUERY on ready --%>
<go:script marker="onready">

	<%-- Clear Non-Alphanumeric on Keyup --%>
	$('#${go:nameFromXpath(xpath)}').keyup(function(){
		$('#${go:nameFromXpath(xpath)}').val( $('#${go:nameFromXpath(xpath)}').val().replace(/[^a-zA-Z 0-9]+/g,'') );
	});

	<%-- Stop Non-Alphanumeric input --%>
	$('#${go:nameFromXpath(xpath)}').live('keydown', function(e) {
		var key = e.charCode ? e.charCode : e.keyCode;
		if( /[^a-zA-Z0-9]/.test(String.fromCharCode(key)) && key!=8 && key!=37 && key!=39 && key!=46) {
		return false;
		} return true;
	});

	<c:if test="${required}">
		<%-- Validate Alphanumeric --%>
		$.validator.addMethod("alphanum",
			function(value, element){
				if( /[^a-zA-Z0-9]/.test( value ) ) {
				return false;
				} return true;
			}, ""
		);
	</c:if>

</go:script>

