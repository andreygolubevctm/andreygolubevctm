<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}_details">

	<form:fieldset legend="Income Protection Details">

		<form:row label="Your gross annual income" helpId="411" className="${name}_income_group">
			<field:currency xpath="${xpath}/income" symbol="" decimal="${false}" maxLength="10" title="Gross Annual Income" required="true" className="number_only" />
		</form:row>

		<form:row label="Benefit Amount" helpId="412" className="${name}_amount_group">
			<field:currency xpath="${xpath}/amount" symbol="" decimal="${false}" maxLength="10" title="Benefit Amount" required="true" className="number_only" />
		</form:row>

		<field:hidden xpath="${xpath}/frequency" defaultValue="M" constantValue="M" />

		<field:hidden xpath="${xpath}/type" defaultValue="S" constantValue="S" />

		<form:row label="Indemnity or Agreed" helpId="405">
			<field:array_select xpath="${xpath}/value" required="true" title="Indemnity or Agreed" items="=Please choose...,I=Indemnity,A=Agreed" />
		</form:row>

		<form:row label="Waiting period" helpId="406">
			<field:array_select xpath="${xpath}/waiting" required="true" title="waiting period" items="=Please choose...,14=14 days,30=30 days,60=60 days,90=90 days,1=1 year,2=2 years" />
		</form:row>

		<form:row label="Benefit period" helpId="407">
			<field:array_select xpath="${xpath}/benefit" required="true" title="benefit period" items="=Please choose...,2=2 years,5=5 years,60=to Age 60,65=to Age 65,70=to Age 70" />
		</form:row>

		<field:hidden xpath="${xpath}/partner" defaultValue="N" constantValue="N" />

	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var InsuranceHandler = {

	calculateBenefit: function( force )
	{
		force = force || false;

		var amt = "";

		var income = $("#${name}_income").val();

		if( String(income).length )
		{
			var income	= InsuranceHandler.filterFloat(income);
			var calc	= InsuranceHandler.getMaxBenefitAmount(income);
			var amount	= $("#${name}_amount").val();

			try{
				amount = Math.floor(InsuranceHandler.filterFloat(String(amount)));

				if( isNaN(amount) )
				{
					amount = 0;
				}
			}catch(e){
				amount = 0;
			};


			if( force == true || amount <= 0 || amount > calc )
			{
				$("#${name}_amountentry").val( calc ).trigger("blur");
			}
			else if( amount > 0 && amount <= calc )
			{
				$("#${name}_amountentry").val( amount ).trigger("blur");
			}
			else
			{
				$("#${name}_amountentry").val("").trigger("blur");
			}
		}
		else
		{
			$("#${name}_amountentry").val("").trigger("blur");
		}
	},

	checkBenefitAmount: function( do_blur )
	{
		do_blur = do_blur || false;

		var income = $("#${name}_income").val();
		var amount = $("#${name}_amount").val();

		if( String(amount).length )
		{
			if( String(income).length )
			{
				income = InsuranceHandler.filterFloat(income);
			}
			else
			{
				income = 0;
			}

			var calc	= InsuranceHandler.getMaxBenefitAmount(income);
			var amount	= $("#${name}_amount").val();

			try{
				amount = Math.floor(InsuranceHandler.filterFloat(String(amount)));

				if( isNaN(amount) )
				{
					amount = 0;
				}
			}catch(e){
				amount = 0;
			};


			if( income > 0 && (amount <= 0 || amount > calc) )
			{
				$("#${name}_amountentry").val( calc );
				$("#${name}_amount").val( calc );
			}
		}
	},

	getMaxBenefitAmount : function(income) {
		return Math.floor(Number(income) * 0.0625).toFixed(0);
	},

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

		if( !$("#${name}_value").val().length )
		{
			$("#${name}_value").val("I");
		}

		if( !$("#${name}_waiting").val().length )
		{
			$("#${name}_waiting").val(30);
		}

		if( !$("#${name}_benefit").val().length )
		{
			$("#${name}_benefit").val("2");
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
	},

	filterFloat : function (value) {
		if( /^\-?([0-9]+(\.[0-9]+)?|Infinity)$/.test( String(value) ) ) {
			return Number(value);
		}
		return NaN;
	}
};
</go:script>

<go:script marker="onready">

	InsuranceHandler.applyDefaults();

	$(function() {
		$("#${name}_partner").buttonset();
	});

	$("#${name}_incomeentry").on("change keyup blur", function(){
		InsuranceHandler.calculateBenefit( true );
	});

	$("#${name}_amountentry").on("blur", function(){
		InsuranceHandler.checkBenefitAmount();
	});

	$("#${name}_incomeentry").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_411').trigger('click')",500);
		return false;
	});

	$("#${name}_amountentry").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_412').trigger('click')",500);
		return false;
	});

	$("#${name}_frequency").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_403').trigger('click')",500);
		return false;
	});

	$("#${name}_type").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_404').trigger('click')",500);
		return false;
	});

	$("#${name}_value").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_405').trigger('click')",500);
		return false;
	});

	$("#${name}_waiting").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_406').trigger('click')",500);
		return false;
	});

	$("#${name}_benefit").on("focus", function(){
		<%-- This delay is needed to circumvent the document click action which hides it. --%>
		var t = setTimeout("$('#help_407').trigger('click')",500);
		return false;
	});

	$(function(){
		var income = $("#${name}_income");
		var incomeParent = $(income).parent();
		var amount = $("#${name}_amount");
		var amountParent = $(amount).parent();

		$(incomeParent).addClass('dollar');
		$(amountParent).addClass('dollar');
		$(incomeParent).append("<span>$</span>");
		$(amountParent).append("<span>$</span>");
	});

	$("#${name}_frequency").on("change", InsuranceHandler.updateResultsPage);

	InsuranceHandler.updateResultsPage();

</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} .clear {
		clear: both;
	}

	#${name} .content {
		position: relative;
	}

	#${name} .${name}_income_group {
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
</go:style>