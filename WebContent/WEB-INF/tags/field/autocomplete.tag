<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Makes an automcomplete field"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="false" rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false" rtexprvalue="true"	 description="subject of the select box" %>
<%@ attribute name="source" 	required="true"	 rtexprvalue="true"	 description="The URL for the Ajax call or a function that will handle the call (and potentially a callback)" %>
<%@ attribute name="select"		required="false" rtexprvalue="true"	 description="The function that will handle the select event" %>
<%@ attribute name="open"		required="false" rtexprvalue="true"	 description="The function that will handle the open event" %>
<%@ attribute name="min" 		required="false" rtexprvalue="true"	 description="The minimum level for the search to return" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value" value="${data[xpath]}" />
<c:if test="${empty min}">
	<c:set var="min" value="${2}" />
</c:if>
<c:if test="${ not source.startsWith('function') }"><c:set var="source">"${source}"</c:set></c:if>

<c:if test="${empty select}">
	<c:set var="select">
		function( event, ui ) {
			log( ui.item ?
				"Selected: " + ui.item.value + " aka " + ui.item.id :
				"Nothing selected, input was " + this.value );
		}
	</c:set>
</c:if>

<c:if test="${empty open}">
	<c:set var="open">
		function( event, ui ) {
			
		}
	</c:set>
</c:if>

<%-- HTML --%>
<input class="ui-autocomplete-input ${className}" id="${name}" name="${name}" value="${data[xpath]}">

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please enter the ${title}"/>

<%-- JavasScript --%>
<go:script marker="onready">
$('#${name}').autocomplete({
	source: ${source},
	minLength: ${min},
	select: ${select},
	focus: function( event, ui ) {
		$('#${name}').val( ui.item.label );
		return false;
	},
	open: ${open}
});
$('#${name}').on('focus', function(){
	if($(this).val() != '' && $(this).val().length >= ${min}) {
		$(this).autocomplete('search', $(this).val());
	}
});
</go:script>

<go:style marker="css-head">
ul.ui-autocomplete {
	background-color: #F9F9F9;
	background-image: -moz-linear-gradient(center top , white, #F3F3F3);
	border: 1px solid #CCC;
	border-radius: 5px 5px 5px 5px;
	color: #666;
	font-size: 12px;
	margin: 3px 0;
	padding: 3px;
	width: 250px;
}
</go:style>