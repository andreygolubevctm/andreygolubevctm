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

<c:if test="${not empty maxLength}"><c:set var="maxLengthStr">maxlength="${maxLength}"</c:set></c:if>
<c:if test="${empty symbol && symbol eq null}"><c:set var="symbol" value="$" /></c:if>
<c:set var="decimal">
	<c:choose>
		<c:when test="${empty decimal && (decimal eq null or decimal eq true)}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${empty nbDecimals}"><c:set var="nbDecimals" value="2" /></c:if>

<%-- The maxlength fails validation once formatting has been added.
	 maxLength provided should be the length without so need to
	 calculate a new length to include formatting. The maxLength
	 value is toggled between the 2 on blur/focus events. --%>
<c:if test="${not empty maxLength}">
	<c:set var="commas" value="${((maxLength/3)+(1-((maxLength/3)%1))%1)-1}" />
	<c:set var="dot" value="${0}" />
	<c:if test="${decimal eq true}"><c:set var="dot" value="${1}" /></c:if>
	<c:set var="symb" value="${0}" />
	<c:if test="${not empty symbol}"><c:set var="symb" value="${1}" /></c:if>
	<c:set var="maxLengthWithFormatting" value="${maxLength + commas + dot + symb}" />
</c:if>

<%-- HTML --%>
<input type="hidden" name="${name}" id="${name}" value="${data[xpath]}"/>
<input type="text" name="${name}entry" id="${name}entry" class="${className}" value="${data[xpath]}" ${maxLengthStr}/>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">
$.validator.addMethod("validate_${name}",
		function(value, elem, parm) {
			try{
				var val = $(elem).val();
				
				if( isNaN(val) )
				{
					val = val.replace(/[^\d.-]/g, '');
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
	<c:if test="${not empty maxLength}">
	$(this).prop('maxLength', ${maxLength});
	</c:if>
	$(this).toNumber();
	$(this).setCursorPosition($(this).val().length, $(this).val().length);
});

$("#${name}entry").on("blur", function() {
	<c:if test="${not empty maxLength}">
	$(this).prop('maxLength', ${maxLengthWithFormatting});
	</c:if>
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