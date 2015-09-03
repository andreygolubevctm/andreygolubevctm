<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's name on credit card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 	rtexprvalue="true"	description="variable's xpath" %>
<%@ attribute name="required" 	required="true"		rtexprvalue="true"  description="is this field required?" %>
<%@ attribute name="defaultValue" 	required="false"	rtexprvalue="true"  description="An optional default value for the field" %>
<%@ attribute name="symbol" 	required="false" 	rtexprvalue="true"  description="Dollar symbol to use" %>
<%@ attribute name="decimal" 	required="false" 	rtexprvalue="true"  description="Flag to show/hide decimals" %>
<%@ attribute name="nbDecimals"	required="false" 	rtexprvalue="true"  description="Number of decimals to show" %>
<%@ attribute name="maxLength" 	required="false"  	rtexprvalue="true"  description="maximum number of digits" %>
<%@ attribute name="minValue" 		required="false" 	rtexprvalue="true"  description="Set a minimum number for input value" %>
<%@ attribute name="maxValue" 		required="false" 	rtexprvalue="true"  description="Set a maximum number for input value" %>
<%@ attribute name="className" 	required="false" 	rtexprvalue="true"	description="additional css class attribute" %>
<%@ attribute name="title" 		required="true"	 	rtexprvalue="true"	description="The subject of the field (e.g. 'regular driver')" %>

<%@ attribute name="percentage" 		required="false" 	rtexprvalue="true"	description="percentage rule validation, expects digits only (eg '10' for 10%)" %>
<%@ attribute name="percentRule" 		required="false" 	rtexprvalue="true"	description="Are we looking for Less Than (LT) or Greater Than (GT)" %>
<%@ attribute name="otherElement" 		required="false"	rtexprvalue="true"	description="The other element we are comparing our percentage rule to if applicable" %>
<%@ attribute name="otherElementName" 	required="false"	rtexprvalue="true"	description="The other element display name. Used for Validation Message" %>
<%@ attribute name="altTitle"		 	required="false"	rtexprvalue="true"	description="Alternative title for percentage rules" %>


<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:if test="${not empty otherElement}">
	<c:set var="otherElement" value="${go:nameFromXpath(otherElement)}" />
</c:if>

<c:if test="${not empty maxLength}"><c:set var="maxLengthStr">maxlength="${maxLength}"</c:set></c:if>
<c:if test="${empty symbol && symbol eq null}"><c:set var="symbol" value="$" /></c:if>
<c:set var="decimal">
	<c:choose>
		<c:when test="${empty decimal && (decimal eq null or decimal eq true)}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>
<c:if test="${empty nbDecimals}"><c:set var="nbDecimals" value="2" /></c:if>
<c:choose>
	<c:when test="${empty data[xpath] and not empty defaultValue}">
		<c:set var="value" value="${defaultValue}" />
	</c:when>
	<c:otherwise>
		<c:set var="value" value="${data[xpath]}" />
	</c:otherwise>
</c:choose>

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
<input type="hidden" name="${name}" id="${name}" value="${dataValue}"/>
<input type="text" name="${name}entry" id="${name}entry" class="${className}" value="${value}" ${maxLengthStr}/>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">

</go:script>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">

$("#${name}entry").on("focus", function() {
	<c:if test="${not empty maxLength}">
	$(this).prop('maxLength', ${maxLength});
	</c:if>
	$(this).toNumber();
	$(this).setCursorPosition($(this).val().length, $(this).val().length);
	if($(this).val() == "${defaultValue}"){
		$(this).val("");
	}
});

$("#${name}entry").on("blur", function() {
	var $this = $(this);

	<c:if test="${not empty maxLength}">
	$this.prop('maxLength', ${maxLengthWithFormatting});
	</c:if>

	<%-- Strip out any non numbers --%>
	$this.val( $.trim( $this.val().replace(/[^\d.-]/g, '') ) );

	if("${defaultValue}" != "" && $this.val() == ""){
		$this.val("${defaultValue}");
	}

	if($this.val() != '') {
		$("#${name}").val( $this.asNumber() );
	} else {
		$("#${name}").val('');
	}

	$this.formatCurrency({symbol:'${symbol}'<c:if test="${decimal eq false}">,roundToDecimalPlace:-${nbDecimals}</c:if>});
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

<c:if test="${not empty minValue}">
	<fmt:formatNumber type="number" value="${minValue}" var="formattedMinValue"/>
	<go:validate selector="${name}entry" rule="${name}_minCurrency" parm="${minValue}" message="${title} cannot be lower than $${formattedMinValue}"/>
</c:if>

<c:if test="${not empty maxValue}">
	<fmt:formatNumber type="number" value="${maxValue}" var="formattedMaxValue"/>
	<go:validate selector="${name}entry" rule="${name}_maxCurrency" parm="${maxValue}" message="${title} cannot be higher than $${formattedMaxValue}"/>
</c:if>

<c:if test="${not empty percentage and not empty otherElement}">
	<c:set var="msgRuleText">
		<c:choose>
			<c:when test="${percentRule == 'LT'}">under</c:when>
			<c:otherwise>at least</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="titleMsg">
		<c:choose>
			<c:when test="${not empty altTitle}">${altTitle }</c:when>
			<c:otherwise>${title }</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="parms">"${otherElement},${percentage},${percentRule}"</c:set>
	<go:validate selector="${name}entry" rule="${name}_percent" parm="${parms}" message="${titleMsg} must be ${msgRuleText} ${percentage }% of ${otherElementName}"/>
</c:if>