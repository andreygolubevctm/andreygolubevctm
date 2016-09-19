<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="primary_label" value="_primary_insurance" />
<c:set var="primary_xpath" value="/primary/insurance" />
<c:set var="partner_label" value="_partner_insurance" />
<c:set var="partner_xpath" value="/partner/insurance" />

<%-- HTML --%>
<div id="${name}_insurance" class="${name}_insurance_details">
	<form_v1:fieldset legend="Life Insurance Details">

		<form_v1:row label="Who is the cover for?" id="${name}${primary_label}_partner_group" >
			<field_v1:array_radio items="N=Just for you,Y=You &amp; your partner" id="${name}${primary_label}_partner" xpath="${xpath}${primary_xpath}/partner" title="who the cover is for" required="true" className="" />
		</form_v1:row>

		<div id="${name}_same_cover_group">
			<form_v1:row label="Would you like to be covered<br>for the same amount?">
				<field_v1:array_radio items="Y=Same cover,N=Different cover" id="${name}${primary_label}_samecover" xpath="${xpath}${primary_xpath}/samecover" title="share the same amount of cover" required="true" className="" />
			</form_v1:row>
		</div>

		<form_v1:row label="Your Term Life Cover" helpId="409" className="${name}${primary_label}_term_group">
			<field_v1:currency xpath="${xpath}${primary_xpath}/term" symbol="" decimal="${false}" maxLength="10" required="false" title="Your Term Life Cover" className="number_only" />
		</form_v1:row>

		<form_v1:row label="Total and Permanent Disability (TPD)" helpId="410" className="${name}${primary_label}_tpd_group">
			<field_v1:currency xpath="${xpath}${primary_xpath}/tpd" symbol="" decimal="${false}" maxLength="10" required="false" title="Total and Permanent Disability" className="number_only" />
		</form_v1:row>

		<form_v1:row label="Trauma Cover" helpId="408" className="${name}${primary_label}_trauma_group">
			<field_v1:currency xpath="${xpath}${primary_xpath}/trauma" symbol="" decimal="${false}" maxLength="10" required="false" title="Trauma Cover" className="number_only" />
			<field_v1:hidden xpath="${xpath}${primary_xpath}/tpdanyown" defaultValue="A" constantValue="A" />
		</form_v1:row>

		<div id="${name}_partner_cover_group">
			<form_v1:row label="Your Partner's Term Life Cover" helpId="409" className="${name}${partner_label}_term_group">
				<field_v1:currency xpath="${xpath}${partner_xpath}/term" symbol="" decimal="${false}" maxLength="10" required="false" title="Your Partner's Term Life Cover" className="number_only" />
			</form_v1:row>

			<form_v1:row label="Total and Permanent Disability (TPD)" helpId="410" className="${name}${partner_label}_tpd_group">
				<field_v1:currency xpath="${xpath}${partner_xpath}/tpd" symbol="" decimal="${false}" maxLength="10" required="false" title="Total and Permanent Disability" className="number_only" />
			</form_v1:row>

			<form_v1:row label="Trauma Cover" helpId="408" className="${name}${partner_label}_trauma_group">
				<field_v1:currency xpath="${xpath}${partner_xpath}/trauma" symbol="" decimal="${false}" maxLength="10" required="false" title="Trauma Cover" className="number_only" />
				<field_v1:hidden xpath="${xpath}${partner_xpath}/tpdanyown" defaultValue="A" constantValue="A" />
			</form_v1:row>
		</div>

		<field_v1:hidden xpath="${xpath}${primary_xpath}/frequency" defaultValue="M" constantValue="M" />

		<field_v1:hidden xpath="${xpath}${primary_xpath}/type" defaultValue="S" constantValue="S" />

		<life_v1:contact_optin vertical="life" />

	</form_v1:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var InsuranceHandler = {

	fields : ['term', 'tpd', 'trauma'],

	applyDefaults: function() {
		if( !$("#${name}${primary_label}_frequency").val().length ) {
			$("#${name}${primary_label}_frequency").val("M");
		}

		if( !$("#${name}${primary_label}_type").val().length ) {
			$("#${name}${primary_label}_type").val("S");
		}

		if( $('input[name=${name}${primary_label}_partner]:checked', '#mainform').val() == undefined ) {
			$('#${name}${primary_label}_partner_N').attr('checked', true).button('refresh');;
		}

		$("#${name}${primary_label}_partner").trigger("change");
	},

	updateResultsPage : function()
	{
		var freq = $("#${name}${primary_label}_frequency").val();
		switch(freq)
		{
			case "M":
			case "H":
			case "Y":
				$("#results_premium_frequency").empty().append( $("#${name}${primary_label}_frequency_" + freq).html() );
				LifeQuote.premiumFrequency = freq;
				break;
			default:
				// ignore
				break;
		}
	},

	toggleShareCoverContent : function(event) {
		if( $(event.target).val() == 'Y' || $('input[name=${name}${primary_label}_partner]:checked', '#mainform').val() == 'Y' ) {
			$('#${name}_insurance .lb-calculator:first').addClass('down');
			$('#${name}_same_cover_group').show();
			$('#${name}_partner').show();

			$('#${name}_same_cover_group').find('input,select').removeClass('dontSubmit');
			$('#${name}_partner').find('input,select').removeClass('dontSubmit');
			$('#${name}_partner_cover_group').find('input,select').removeClass('dontSubmit');
		} else {
			$('#${name}_same_cover_group').hide();
			$('#${name}_partner').hide();
			$('#${name}_insurance .lb-calculator:first').removeClass('down');

			$('#${name}_partner').find('input,select').addClass('dontSubmit');
			$('#${name}_same_cover_group').find('input,select').addClass('dontSubmit');
			$('#${name}_partner_cover_group').find('input,select').addClass('dontSubmit');
		}

		$(document).ready(function(){
			var $primaryElement = LifeAccordion.getSectionElement('personal', 'content').primary;

			if($primaryElement.is(':visible')) {
				var $nextElement = $primaryElement.find('.next-button:first');
				var $partner = $primaryElement.parents('.life_primary_details').next('span');

				if( LifeAccordionIsPartnerQuote() ) {
					$nextElement.hide();
					$partner.show();
				} else {
					$nextElement.show();
					$partner.hide();
				}
			}
		});

		InsuranceHandler.togglePartnerCoverContent();
	},

	togglePartnerCoverContent : function(event) {
		event = event || false;

		if(
			$('input[name=${name}${primary_label}_partner]:checked').val() == 'Y' &&
			($(event.target).val() == 'N' || $('input[name=${name}${primary_label}_samecover]:checked', '#mainform').val() == 'N')
		) {
			$('#${name}_partner_cover_group').show();
		} else {
			$('#${name}_partner_cover_group').hide();

			if( $("label.error[for='life_partner_insurance_termentry']").length ) {
				$("label.error[for='life_partner_insurance_termentry']").remove();
			}
		}
	}
};

var minInsuranceSelected = function(type) {

	var is_valid = false;

	for(var i = 0; i < InsuranceHandler.fields.length; i++) {
		var field = InsuranceHandler.fields[i];
		var value = $('#${name}_' + type + '_insurance_' + field + 'entry').val();

		if( value != '' && value != 0 ) {
			is_valid = true;
			break;
		}

		if( is_valid ) {
			break;
		}
	}
	if(  is_valid )	{
		for(var j = 0; j < InsuranceHandler.fields.length; j++) {
			$('#${name}_' + type + '_insurance_' + InsuranceHandler.fields[j] + 'entry').removeClass('error');
		}
	} else {
		for(var k = 0; k < InsuranceHandler.fields.length; k++) {
			$('#${name}_' + type + '_insurance_' + InsuranceHandler.fields[k] + 'entry').addClass('error');
		}
	}

	return is_valid;
};

// Custom Validation
$.validator.addMethod("minPrimaryInsuranceSelected",
	function(value, element) {
		return minInsuranceSelected('primary');
	},
	"Please enter a dollar value for at least one insurance type"
);
$.validator.addMethod("minPartnerInsuranceSelected",
	function(value, element) {
		return minInsuranceSelected('partner');
	},
	"Please enter a dollar value for at least one insurance type"
);
</go:script>

<go:script marker="onready">

	$(function() {
		$("#${name}${primary_label}_partner").buttonset();
		$("#${name}${primary_label}_samecover").buttonset();
	});

	$("#${name}${primary_label}_partner").change(function(e){
		InsuranceHandler.toggleShareCoverContent(e);
	});

	$("#${name}${primary_label}_samecover").change(function(e){
		InsuranceHandler.togglePartnerCoverContent(e);
	});

	InsuranceHandler.applyDefaults();

	$(function(){
		var list = ['primary','partner'];

		for(var i=0; i < list.length; i++) {
			var term = $("#${name}_" + list[i] + "_insurance_term");
			var termParent = $(term).parent();
			var tpd = $("#${name}_" + list[i] + "_insurance_tpd");
			var tpdParent = $(tpd).parent();
			var trauma = $("#${name}_" + list[i] + "_insurance_trauma");
			var traumaParent = $(trauma).parent();

			$(termParent).addClass('dollar');
			$(tpdParent).addClass('dollar');
			$(traumaParent).addClass('dollar');
			$(termParent).append("<span>$</span>");
			$(tpdParent).append("<span>$</span>");
			$(traumaParent).append("<span>$</span>");
		}
	});

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

	<%--
	Start index for help tooltips.
	If we ever need to shuffle the accordion around in future,
	this will let us make one change instead of 6.
	--%>
	<c:set var="tooltipInitialValue">0</c:set>

	$('#${name}${primary_label}_termentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('.help_icon').eq(${tooltipInitialValue}).trigger('click')",500);
		return false;
	});

	$('#${name}${primary_label}_tpdentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('.help_icon').eq(${tooltipInitialValue + 1}).trigger('click')",500);
		return false;
	});

	$('#${name}${primary_label}_traumaentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('.help_icon').eq(${tooltipInitialValue + 2}).trigger('click')",500);
		return false;
	});

	$('#${name}${partner_label}_termentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('.help_icon').eq(${tooltipInitialValue + 3}).trigger('click')",500);
		return false;
	});

	$('#${name}${partner_label}_tpdentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('.help_icon').eq(${tooltipInitialValue + 4}).trigger('click')",500);
		return false;
	});

	$('#${name}${partner_label}_traumaentry').on('focus', function(e){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('.help_icon').eq(${tooltipInitialValue + 5}).trigger('click')",500);
		return false;
	});

</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${name}_insurance .clear {
		clear: both;
	}

	#${name}_insurance .content {
		position: relative;
	}

	#${name}_insurance .lb-calculator {
		top: 64px;
	}

	#${name}_insurance .lb-calculator.down {
		top: 111px;
	}

	#${name}_insurance .${name}${primary_label}_tpd_group .fieldrow_label,
	#${name}_insurance .${name}${partner_label}_tpd_group .fieldrow_label {
		text-indent:50px;
	}
	#${name}_insurance .${name}${primary_label}_term_group,
	#${name}_insurance .${name}${primary_label}_tpd_group,
	#${name}_insurance .${name}${primary_label}_trauma_group,
	#${name}_insurance .${name}${partner_label}_term_group,
	#${name}_insurance .${name}${partner_label}_tpd_group,
	#${name}_insurance .${name}${partner_label}_trauma_group {
		min-height:0;
	}

	#${name}_insurance .fieldrow_value.dollar {
		position: relative;
	}

	#${name}_insurance .fieldrow_value.dollar input {
		padding-left: 11px;
	}

	#${name}_insurance .fieldrow_value.dollar span {
		position: absolute;
		width: 10px;
		height: 12px;
		top: 9px;
		left: 4px;
	}

	#${name}_insurance .${name}${primary_label}_tpd_group .fieldrow_value,
	#${name}_insurance .${name}${partner_label}_tpd_group .fieldrow_value {
		margin-top: 9px;
	}

	#${name}_insurance .${name}${primary_label}_tpd_group .help_icon,
	#${name}_insurance .${name}${partner_label}_tpd_group .help_icon {
		margin-top: 17px;
	}

	#${name}${primary_label}_partner span,
	#${name}${primary_label}_samecover span {
		padding-left: 0;
		padding-right: 0;
		width: 150px;
	}

	#${name}${primary_label}_partner_group {
		margin-top: 8px;
		margin-bottom: 8px;
	}

	#${name}_same_cover_group {
		margin-top: -8px;
		margin-bottom: 3px;
	}

	#${name}${primary_label}_samecover {
		margin-top: 10px;
	}

	#${name}_partner_cover_group {
		margin-top: 8px;
	}

	#${name}_same_cover_group,
	#${name}_partner_cover_group {
		display: none;
	}
</go:style>

<%-- VALIDATION --%>
<go:validate selector="${name}${primary_label}_termentry" rule="minPrimaryInsuranceSelected" parm="true" message="Please enter a dollar value for at least one insurance type for you" />
<go:validate selector="${name}${partner_label}_termentry" rule="minPartnerInsuranceSelected" parm="true" message="Please enter a dollar value for at least one insurance type for your partner" />
