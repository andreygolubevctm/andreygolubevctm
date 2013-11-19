<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a mobile phone number"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="elementName" 	required="true" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="placeholder"	required="true" rtexprvalue="true"	 description="s" %>

<%-- handle browsers that don't support place holders --%>
if (document.createElement("input").placeholder == undefined) {
	var inputElement = $('#${elementName}');
	var currValue = inputElement.val();
	if(currValue == ''){
		inputElement.val('${placeholder}');
	}

	inputElement.on('focus', function() {
		var currValue = $(this).val();
		if(currValue == '${placeholder}') {
			$(this).val('');
		}
	});
	inputElement.on('blur', function() {
		var currValue = $(this).val();
		if(currValue == ''){
			$(this).val('${placeholder}');
		}
	});
}