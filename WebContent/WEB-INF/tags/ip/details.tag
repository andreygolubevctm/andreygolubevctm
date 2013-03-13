<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="sub" 		required="false"	 rtexprvalue="true"	 description="Substitute an identifier e.g Partner's" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="ip_details">
	
	<form:fieldset legend="${sub} Income Protection Details">
		
		<form:row label="Your gross annual income" helpId="411" className="ip_details_insurance_income_group">
			<field:currency xpath="${xpath}/insurance/income" symbol="" decimal="${false}" maxLength="15" title="Gross Annual Income" required="true" />
		</form:row>
		
		<form:row label="Benefit Amount" helpId="412" className="ip_details_insurance_amount_group">
			<field:currency xpath="${xpath}/insurance/amount" symbol="" decimal="${false}" maxLength="15" title="Benefit Amount" required="true" />
		</form:row>
		
		<form:row label="Premium Frequency" helpId="403">
			<field:array_select xpath="${xpath}/insurance/frequency" required="true" title="premium frequency" items="=Please choose...,M=Monthly,H=Half Yearly,Y=Annually" />
		</form:row>

		<form:row label="Premium Type" helpId="404">
			<field:array_select xpath="${xpath}/insurance/type" required="true" title="premium type" items="=Please choose...,S=Stepped,L=Level" />
		</form:row>

		<form:row label="Indemnity or Agreed" helpId="405">
			<field:array_select xpath="${xpath}/insurance/value" required="true" title="Indemnity or Agreed" items="=Please choose...,I=Indemnity,A=Agreed" />
		</form:row>

		<form:row label="Waiting period" helpId="406">
			<field:array_select xpath="${xpath}/insurance/waiting" required="true" title="waiting period" items="=Please choose...,14=14 days,30=30 days,60=60 days,90=90 days,180=180 days,1=1 year,2=2 years" />
		</form:row>

		<form:row label="Benefit period" helpId="407">
			<field:array_select xpath="${xpath}/insurance/benefit" required="true" title="benefit period" items="=Please choose...,1=1 year,2=2 years,5=5 years,10=10 years,55=to Age 55,60=to Age 60,65=to Age 65,70=to Age 70" />
		</form:row>
		
		<life:popup_calculator />
		
	</form:fieldset>		
	
	<form:fieldset legend="${sub} Personal Details">	
	
		<form:row label="First name" className="halfrow">
			<field:input xpath="${xpath}/firstName" title="first name" required="true" size="13" />
		</form:row>

		<form:row label="Surname" className="halfrow right">
			<field:input xpath="${xpath}/lastname" title="surname" required="true" size="13" />
		</form:row>
		
		<div class="clear"><!-- empty --></div>
		
		<form:row label="Gender">
			<field:array_radio  id="${name}_gender" xpath="${xpath}/gender" required="false" title="gender" items="F=Female,M=Male" />
		</form:row>
		
		<form:row label="Date of birth">
			<field:person_dob xpath="${xpath}/dob" required="true" title="person's" />
		</form:row>	
		
		<field:hidden xpath="${xpath}/age" required="false" />
		
		<form:row label="Smoker status">
			<field:array_radio  id="${name}_smoker" xpath="${xpath}/smoker" required="false" title="smoker status" items="N=Non-Smoker,Y=Smoker" />
		</form:row>
		
		<form:row label="Occupation">
			<field:general_select type="occupation" xpath="${xpath}/occupation" required="false" title="${sub} occupation"/>
		</form:row>	
		
		<form:row label="Postcode">
			<field:post_code_and_state xpath="${xpath}/postCode" title="postcode" required="true" className="ip_contact_details" />
		</form:row>

		<%--<form:row label="Would you like to insure your partner">
			<field:array_radio items="Y=Yes,N=No" id="${name}_partner" xpath="${xpath}/partner" title="insure partner" required="false" className="" />	
		</form:row>--%>
		<field:hidden xpath="${xpath}/partner" defaultValue="N" constantValue="N" />	
		
	</form:fieldset>	

</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var DetailsHandler = {
	getAgeAtNextBday: function(dob) 
	{
		var dob_pieces = dob.split("/");
		var year = Number(dob_pieces[2]);
		var month = Number(dob_pieces[1]) - 1;
		var day = Number(dob_pieces[0]);
		var today = new Date();
		var age = today.getFullYear() - year;
		
		return age;
	},
	
	calculateBenefit: function( force )
	{
		force = force || false; 
		
		var amt = "";
		
		var income = $("#${name}_insurance_income").val();
		
		if( String(income).length )
		{
			var income	= parseFloat(income);
			var calc	= Number(income * 0.0625);
			var amount	= $("#${name}_insurance_amount").val();
			
			try{
				amount = parseFloat(String(amount));
				
				if( isNaN(amount) )
				{
					amount = 0;
				}
			}catch(e){
				amount = 0;
			};
			
			
			if( force == true || amount <= 0 || amount > calc )
			{
				$("#${name}_insurance_amountentry").val( calc.toFixed(2) ).trigger("blur");
			}
			else if( amount > 0 && amount <= calc )
			{
				$("#${name}_insurance_amountentry").val( amount.toFixed(2) ).trigger("blur");
			}
			else
			{
				$("#${name}_insurance_amountentry").val("").trigger("blur");
			}
		}
		else
		{
			$("#${name}_insurance_amountentry").val("").trigger("blur");
		}
	},
	
	checkBenefitAmount: function()
	{
		var income = $("#${name}_insurance_income").val();
		var amount = $("#${name}_insurance_amount").val();
		
		if( String(amount).length )
		{
			if( String(income).length )
			{
				income = parseFloat(income);
			}
			else
			{
				income = 0;
			}
			
			var calc	= Number(income * 0.0625);
			var amount	= $("#${name}_insurance_amount").val();
			
			try{
				amount = parseFloat(String(amount));
				
				if( isNaN(amount) )
				{
					amount = 0;
				}
			}catch(e){
				amount = 0;
			};
			
			
			if( income > 0 && (amount <= 0 || amount > calc) )
			{
				$("#${name}_insurance_amountentry").val( calc.toFixed(2) ).trigger("blur");
			}
		}
	},
	
	applyDefaults: function()
	{
		if( !$("#${name}_insurance_frequency").val().length )
		{
			$("#${name}_insurance_frequency").val("M");
		}
		
		if( !$("#${name}_insurance_type").val().length )
		{
			$("#${name}_insurance_type").val("S");
		}
		
		if( !$("#${name}_insurance_value").val().length )
		{
			$("#${name}_insurance_value").val("I");
		}
		
		if( !$("#${name}_insurance_waiting").val().length )
		{
			$("#${name}_insurance_waiting").val(30);
		}
		
		if( !$("#${name}_insurance_benefit").val().length )
		{
			$("#${name}_insurance_benefit").val("2");
		}
		
		if( $('input[name=${name}_smoker]:checked', '#mainform').val() == undefined )
		{
			$('#${name}_smoker_N').attr('checked', true).button('refresh');		
		}
		
		if( $('input[name=${name}_partner]:checked', '#mainform').val() == undefined )
		{
			$('#${name}_partner_N').attr('checked', true).button('refresh');;
		}
	},
	
	updateResultsPage : function()
	{
		var freq = $("#${name}_insurance_frequency").val();
		switch(freq)
		{
			case "M":
			case "H":
			case "Y":
				$("#results_premium_frequency").empty().append( $("#${name}_insurance_frequency_" + freq).html() );
				IPQuote.premiumFrequency = freq;
				break;
			default:
				// ignore
				break;
		}
	}
};

$.validator.addMethod("validateAge",
	function(value, element) {
		var getAge = function(dob) {
			var dob_pieces = dob.split("/");
			var year = Number(dob_pieces[2]);
			var month = Number(dob_pieces[1]) - 1;
			var day = Number(dob_pieces[0]);
			var today = new Date();
			var age = today.getFullYear() - year;

			return age;
		}
		
		var age = getAge( value );
		
		if( age < 18 || age > 65 )
		{
			return false;
		}

		return true;
	},
	"Replace this message with something else"
);
</go:script>

<go:script marker="onready">
	
	DetailsHandler.applyDefaults();
	
	$(function() {
		$("#${name}_smoker, #${name}_gender, #${name}_partner").buttonset();
	});
	
	$("#${name}_insurance_incomeentry").on("change keyup blur", function(){
		DetailsHandler.calculateBenefit( true );
	});
	
	$("#${name}_insurance_amountentry").on("blur", function(){
		DetailsHandler.checkBenefitAmount();
	});
	
	$("#${name}_partner input[name='life_details_primary_partner']").on('change', function(){
		/* PATIENCE - NOTHING TO DO HERE YET */
	});
	
	if( $('#${name}_dob').val().length )
	{
		$('#${name}_age').val(DetailsHandler.getAgeAtNextBday( $('#${name}_dob').val() ));
	}
	
	$('#${name}_dob').on("change keyup", function(){
		$('#${name}_age').val(DetailsHandler.getAgeAtNextBday( $('#${name}_dob').val() ) );	
	});
	
	$(function(){
		var income = $("#${name}_insurance_income");
		var incomeParent = $(income).parent();
		var amount = $("#${name}_insurance_amount");
		var amountParent = $(amount).parent();
		
		$(incomeParent).addClass('dollar');
		$(amountParent).addClass('dollar');
		$(incomeParent).append("<span>$</span>");
		$(amountParent).append("<span>$</span>");
	});
	
	$("#${name}_insurance_frequency").on("change", DetailsHandler.updateResultsPage);
	
	DetailsHandler.updateResultsPage();
	
	
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} .clear {
		clear: both;
	}
	
	#${name} .content {
		position: relative;
	}
	
	#${name} .life_details_insurance_income_group {
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
	
	#${name}_occupation {
		width: 407px;
	}
</go:style>

<go:validate selector="${name}_dob" rule="validateAge" parm="true" message="Age must be between 18 and 65." />
