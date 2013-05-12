<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 	required="true"		rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="symbol" 	required="false" 	rtexprvalue="true"  description="Dollar symbol to use" %>
<%@ attribute name="decimal" 	required="false" 	rtexprvalue="true"  description="Flag to show/hide decimals" %>
<%@ attribute name="nbDecimals"	required="false" 	rtexprvalue="true"  description="Number of decimals to show" %>
<%@ attribute name="maxLength" 	required="false"  	rtexprvalue="true"  description="maximum number of digits" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 	rtexprvalue="true"	description="The subject of the field (e.g. 'regular driver')" %>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<c:if test="${not empty maxLength}"><c:set var="maxLength">maxlength="${maxLength}"</c:set></c:if>
<c:if test="${empty symbol && symbol eq null}"><c:set var="symbol" value="$" /></c:if>
<c:set var="decimal">
	<c:choose>
		<c:when test="${empty decimal && (decimal eq null or decimal eq true)}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${empty nbDecimals}"><c:set var="nbDecimals" value="2" /></c:if>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" value="${data[xpath]}"/>
<input type="text" name="${name}entry" id="${name}entry" class="${className}" value="${data[xpath]}" ${maxLength}/>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">
$.validator.addMethod("validate_${name}",
		function(value, elem, parm) {
			try{
				var val = $("#${name}").val();
				
				if( isNaN(val) )
				{
					val = parseFloat( val );
				}
				
				if( val > 0 )
				{
					return true;
				}
				
				return false;
			}
			catch(e) 
			{
				return false;
			}   				
		},
		
		$.validator.messages.currencyNumber = ' is not a valid number.'
);
</go:script>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

$("#${name}entry").on("focus", function() {
	$(this).toNumber();
	$(this).setCursorPosition($(this).val().length, $(this).val().length);
});

$("#${name}entry").on("blur", function() {
	$("#${name}").val( $(this).asNumber() );
	$(this).formatCurrency({symbol:'${symbol}'<c:if test="${decimal eq false}">,roundToDecimalPlace:-${nbDecimals}</c:if>});
});

$("#${name}entry").trigger("blur");

$.fn.setCursorPosition = function(pos) {
	if ($(this).get(0).setSelectionRange) {
		$(this).get(0).setSelectionRange(pos, pos);
	} else if ($(this).get(0).createTextRange) {
		var range = $(this).get(0).createTextRange();
		range.collapse(true);
		range.moveEnd('character', pos);
		range.moveStart('character', pos);
		range.select();
	}
}

<c:if test="${not empty showSymbol && showSymbol ne null}">
	if($("#${name}entry").val() == "") {
		$("#${name}entry").val('${symbol}');
	}
</c:if>

</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}entry" rule="validate_${name}" parm="${required}" message="${title} is not a valid amount"/>