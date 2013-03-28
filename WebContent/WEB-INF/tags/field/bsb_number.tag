<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 rtexprvalue="true"	 description="The subject of the field (e.g. 'regular driver')"%>

<%-- VARIABLES --%>
<c:set var="bsbnumber" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<input type="hidden" name="${bsbnumber}" id="${bsbnumber}" class="" value="${data[xpath]}">
<input type="text" name="${bsbnumber}input" id="${bsbnumber}input" class="bsb_number ${className} numeric" value="${data[xpath]}" size="8" maxlength="7">

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">
	jQuery("#${bsbnumber}input").mask("999-999",{placeholder:"_"});
</go:script>

<go:script marker="onready">
$("#${bsbnumber}input").on("focus blur", function(){
	$("#${bsbnumber}").val( String($("#${bsbnumber}input").val()).replace(/[^0-9]/g, '') ); 
});
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${bsbnumber}input" rule="required" parm="${required}" message="Please enter ${title}"/>
<field:highlight_row name="${go:nameFromXpath(xpath)}input" inlineValidate="${required}" />