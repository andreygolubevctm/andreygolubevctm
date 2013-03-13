<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's date of birth."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<input type="text" name="${name}" id="${name}" class="diary_date" value="${data[xpath]}" title="${title}" size="12"  />

<%-- JQUERY UI --%>
<go:script marker="jquery-ui">
	jQuery("#${name}").datepicker({
		minDate: '+0d',
		dateFormat: 'dd/mm/yy',
		constrainInput: true,
		autoSize: true,
		showAnim: 'blind',
	});
	jQuery("#${name}").click(function(){
		jQuery("#${name}").val('');
	});
	
</go:script>

<go:style marker="css-head">
    .ui-datepicker {
    	margin-left:0px;
    	margin-top:0px;
    }
</go:style>