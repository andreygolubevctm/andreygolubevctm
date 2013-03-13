<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description=""%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"		 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="sub" 		required="false"	 rtexprvalue="true"	 description="Substitute an identifier e.g Partner's" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="life_details">
	
	<form:fieldset legend="${sub} Life Insurance Details">
		
		<form:row label="Term Life Cover" helpId="409" className="life_details_insurance_term_group">
			<field:currency xpath="${xpath}/insurance/term" symbol="" decimal="${false}" maxLength="15" required="true" title="Term Life Cover" />
		</form:row>
		
		<form:row label="Total and Permanent Disability (TPD)" helpId="410" className="life_details_insurance_tpd_group">
			<field:currency xpath="${xpath}/insurance/tpd" symbol="" decimal="${false}" maxLength="15" required="true" title="Total and Permanent Disability" />
		</form:row>

		<form:row label="Trauma Cover" helpId="408" className="life_details_insurance_trauma_group">
			<field:currency xpath="${xpath}/insurance/trauma" symbol="" decimal="${false}" maxLength="15" required="true" title="Trauma Cover"  />
		</form:row>
		
		<form:row label="Premium Frequency" helpId="403">
			<field:array_select xpath="${xpath}/insurance/frequency" required="true" title="premium frequency" items="=Please choose...,M=Monthly,H=Half Yearly,Y=Annually" />
		</form:row>

		<form:row label="Premium Type" helpId="404">
			<field:array_select xpath="${xpath}/insurance/type" required="true" title="premium type" items="=Please choose...,S=Stepped,L=Level" />
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
			<field:array_radio  id="${name}_gender" xpath="${xpath}/gender" required="true" title="gender" items="F=Female,M=Male" />
		</form:row>
		
		<form:row label="Date of birth">
			<field:person_dob xpath="${xpath}/dob" required="true" title="person's" />
		</form:row>	
		
		<field:hidden xpath="${xpath}/age" required="false" />
		
		<form:row label="Smoker status">
			<field:array_radio  id="${name}_smoker" xpath="${xpath}/smoker" required="true" title="smoker status" items="N=Non-Smoker,Y=Smoker" />
		</form:row>
		
		<form:row label="Occupation">
			<field:general_select type="occupation" xpath="${xpath}/occupation" required="true" title="${sub} occupation"/>
		</form:row>	
		
		<form:row label="Postcode">
			<field:post_code_and_state xpath="${xpath}/postCode" title="postcode" required="true" className="health_contact_details" />
		</form:row>

		<%--<form:row label="Would you like to insure your partner">
			<field:array_radio items="Y=Yes,N=No" id="${name}_partner" xpath="${xpath}/partner" title="insure partner" required="true" className="" />	
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
				LifeQuote.premiumFrequency = freq;
				break;
			default:
				// ignore
				break;
		}
	}
};
</go:script>

<go:script marker="onready">	

	DetailsHandler.applyDefaults();
	
	$(function() {
		$("#${name}_smoker, #${name}_gender, #${name}_partner").buttonset();
	});
	
	$("#${name}_partner input[name='life_details_primary_partner']").on('change', function(){
		//LifeEngine.setPartner();
	});
	
	if( $('#${name}_dob').val().length )
	{
		$('#${name}_age').val(DetailsHandler.getAgeAtNextBday( $('#${name}_dob').val() ));
	}
	
	$('#${name}_dob').on("change keyup", function(){
		$('#${name}_age').val(DetailsHandler.getAgeAtNextBday( $('#${name}_dob').val() ) );	
	});
	
	$(function(){
		var term = $("#${name}_insurance_term");
		var termParent = $(term).parent();
		var tpd = $("#${name}_insurance_tpd");
		var tpdParent = $(tpd).parent();
		var trauma = $("#${name}_insurance_trauma");
		var traumaParent = $(trauma).parent();
		
		$(termParent).addClass('dollar');
		$(tpdParent).addClass('dollar');
		$(traumaParent).addClass('dollar');
		$(termParent).append("<span>$</span>");
		$(tpdParent).append("<span>$</span>");
		$(traumaParent).append("<span>$</span>");
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
	
	#${name} .life_details_insurance_tpd_group .fieldrow_label {
		text-indent:50px;	
	}
	#${name} .life_details_insurance_term_group,
	#${name} .life_details_insurance_tpd_group,
	#${name} .life_details_insurance_trauma_group {
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
