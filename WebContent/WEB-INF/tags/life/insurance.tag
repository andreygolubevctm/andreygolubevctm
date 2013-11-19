<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="is_primary">
	<c:choose>
		<c:when test="${fn:contains(name,'primary')}">${true}</c:when>
		<c:otherwise>${false}</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="${name}" class="${name}_details">
	<form:fieldset legend="Life Insurance Details">

		<form:row label="Term Life Cover" helpId="409" className="${name}_term_group">
			<field:currency xpath="${xpath}/term" symbol="" decimal="${false}" maxLength="10" required="false" title="Term Life Cover" className="number_only" />
		</form:row>

		<form:row label="Total and Permanent Disability (TPD)" helpId="410" className="${name}_tpd_group">
			<field:currency xpath="${xpath}/tpd" symbol="" decimal="${false}" maxLength="10" required="false" title="Total and Permanent Disability" className="number_only" />
		</form:row>

		<form:row label="Trauma Cover" helpId="408" className="${name}_trauma_group">
			<field:currency xpath="${xpath}/trauma" symbol="" decimal="${false}" maxLength="10" required="false" title="Trauma Cover" className="number_only" />
		</form:row>

		<field:hidden xpath="${xpath}/frequency" defaultValue="M" constantValue="M" />

		<field:hidden xpath="${xpath}/type" defaultValue="S" constantValue="S" />

	<c:if test="${is_primary eq true}">
		<form:row label="Who is the cover for?">
			<field:array_radio items="N=Just for you,Y=You and your partner" id="${name}_partner" xpath="${xpath}/partner" title="who the cover is for" required="true" className="" />
		</form:row>
	</c:if>

		<life:popup_calculator />

	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var InsuranceHandler = {

	fields : ['term', 'tpd', 'trauma'],

	applyDefaults: function()
	{
		if( !$("#${name}_frequency").val().length )
		{
			$("#${name}_frequency").val("M");
		}

		if( !$("#${name}_type").val().length )
		{
			$("#${name}_type").val("S");
		}

		if( $('input[name=${name}_partner]:checked', '#mainform').val() == undefined )
		{
			$('#${name}_partner_N').attr('checked', true).button('refresh');;
		}
	},

	updateResultsPage : function()
	{
		var freq = $("#${name}_frequency").val();
		switch(freq)
		{
			case "M":
			case "H":
			case "Y":
				$("#results_premium_frequency").empty().append( $("#${name}_frequency_" + freq).html() );
				LifeQuote.premiumFrequency = freq;
				break;
			default:
				// ignore
				break;
		}
	}
};

// Custom Validation
$.validator.addMethod("minInsuranceSelected",
	function(value, element) {

		var is_valid = false;

		for(var i = 0; i < InsuranceHandler.fields.length; i++) {
			var field = InsuranceHandler.fields[i];
			if( $('#${name}_' + field + 'entry').val() != '' ) {
				is_valid = true;
				break;
			}

			if( is_valid ) {
				break;
			}
		}
		if(  is_valid )	{
			for(var j = 0; j < InsuranceHandler.fields.length; j++) {
				$('#${name}_' + InsuranceHandler.fields[j] + 'entry').removeClass('error');
			}
		} else {
			for(var k = 0; k < InsuranceHandler.fields.length; k++) {
				$('#${name}_' + InsuranceHandler.fields[k] + 'entry').addClass('error');
			}
		}

		return is_valid;
	},
	"Please enter a dollar value for at least one insurance type"
);
</go:script>

<go:script marker="onready">

	$('#${name}_partner').buttonset();

	InsuranceHandler.applyDefaults();

	$(function(){
		var term = $("#${name}_term");
		var termParent = $(term).parent();
		var tpd = $("#${name}_tpd");
		var tpdParent = $(tpd).parent();
		var trauma = $("#${name}_trauma");
		var traumaParent = $(trauma).parent();

		$(termParent).addClass('dollar');
		$(tpdParent).addClass('dollar');
		$(traumaParent).addClass('dollar');
		$(termParent).append("<span>$</span>");
		$(tpdParent).append("<span>$</span>");
		$(traumaParent).append("<span>$</span>");
	});

	$("#${name}_frequency").on("change", InsuranceHandler.updateResultsPage);

	InsuranceHandler.updateResultsPage();

	// If checkbox changes re-validate form
	for(var i = 0; i < InsuranceHandler.fields.length; i++) {
		var field = InsuranceHandler.fields[i];
		$('#${name}_' + field + 'entry').change(function(){
			if($('#${name}_' + field + 'entry').hasClass("error")){
				QuoteEngine.validate();
			}
		});
	}

	$('#${name}_termentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_409').trigger('click')",500);
		return false;
	});

	$('#${name}_tpdentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_410').trigger('click')",500);
		return false;
	});

	$('#${name}_traumaentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_408').trigger('click')",500);
		return false;
	});

	$('#${name}_frequency').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_403').trigger('click')",500);
		return false;
	});

	$('#${name}_type').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_404').trigger('click')",500);
		return false;
	});

</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} .clear {
		clear: both;
	}

	#${name} .content {
		position: relative;
	}

	#${name} .${name}_tpd_group .fieldrow_label {
		text-indent:50px;
	}
	#${name} .${name}_term_group,
	#${name} .${name}_tpd_group,
	#${name} .${name}_trauma_group {
		min-height:0;
	}

	#${name} .fieldrow_value.dollar {
		position: relative;
	}

	#${name} .fieldrow_value.dollar input {
		padding-left: 11px;
	}

	#${name} .fieldrow_value.dollar span {
		position: absolute;
		width: 10px;
		height: 12px;
		top: 9px;
		left: 4px;
	}

	#${name}_existing_term_policy,
	#${name}_existing_tpd_policy,
	#${name}_existing_trauma_policy {
		margin-top: 9px !important;
	}

	#${name} .${name}_tpd_group .fieldrow_value {
		margin-top: 9px;
	}

	#${name} .${name}_tpd_group .help_icon {
		margin-top: 17px;
	}
</go:style>

<%-- VALIDATION --%>
<go:validate selector="${name}_termentry" rule="minInsuranceSelected" parm="true" message="Please enter a dollar value for at least one insurance type" />