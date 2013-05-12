<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="field_email" 	value="${name}_email" />
<c:set var="field_mobile"	value="${name}_mobileinput" />


<%-- HTML --%>
<div id="${name}-selection" class="health_application-details">

	<form:fieldset legend="Your Contact Details">

		<h5>Residential Address</h5>
		<group:address xpath="${xpath}/address" type="R" />
		<core:clear />
		
		<%-- POSTAL defaults to Y if not pre-loaded --%>
		<c:if test="${ (empty data[xpath].postalMatch) && (empty data['health/contactDetails/email']) }">
			<go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
		</c:if>	
		
		<h5>Postal Address</h5>
		<form:row label=" " >		
			<field:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
		</form:row>
		
		<div id="${name}_postalGroup">			
			<group:address xpath="${xpath}/postal" type="P" />
		</div>

		<h5>Please enter at least 1 phone number</h5>
		
		<form:row label="Mobile" className="halfrow" id="${name}_mobile-group">
			<field:contact_mobile xpath="${xpath}/mobile" required="false" />
		</form:row>
		
		<form:row label="Other Number" className="halfrow right" id="${name}_other-group">
			<field:contact_telno xpath="${xpath}/other" required="false" />
		</form:row>
		
		<core:clear />
		
		<form:row label="Email address" id="${name}_emailGroup">
			<span class="fieldrow_legend" id="${name}_emailMessage">we'll send your confirmation here</span>
			<field:contact_email xpath="${xpath}/email" title="your email address" required="true" size="40" />			
		</form:row>
		
		<simples:dialogue id="14" mandatory="true" />
		
		<form:row label=" " id="${name}_optInEmail-group" >
			<field:checkbox xpath="${xpath}/optInEmail" value="Y" title="I agree to receive news and offer emails from Compare the Market" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
		</form:row>
		
		<%-- Default contact Point to off --%>
		<form:row label="How would you like <span>the Fund</span> to send you information" id="${name}_contactPoint-group" className="health_application-details_contact-group">
			<field:array_radio items="E=Email,P=Post" xpath="${xpath}/contactPoint" title="like the fund to contact you" required="false" id="${name}_contactPoint" />
		</form:row>
		
		<%-- Product Information --%>
		<field:hidden xpath="${xpath}/provider" className="health_application_details_provider" />
		<field:hidden xpath="${xpath}/productId" className="health_application_details_productId" />
		<field:hidden xpath="${xpath}/productName" className="health_application_details_productNumber" />
		<field:hidden xpath="${xpath}/productTitle" className="health_application_details_productTitle" />
		<field:hidden xpath="${xpath}/paymentAmt" className="health_application_details_paymentAmt" />
		<field:hidden xpath="${xpath}/paymentFreq" className="health_application_details_paymentFreq" />
	
	</form:fieldset>

</div>


<%-- CSS --%>
<go:style marker="css-head">
	#${name}_postalGroup {
		min-height:0;
	}
	#${name}_address_nonStd_row.nonStdShown,
	#${name}_postal_nonStd_row.nonStdShown {
		position:relative;
		left:0;
		top:-15px;
		float:left;
		width:300px;
		margin:0px;
	}
	#${name}_address_unitShowRow,
	#${name}_postal_unitShowRow,
	#${name}_address_unitShopRow,
	#${name}_postal_unitShopRow  {
		width:300px;
		float:left;
	}
	#${name}_mobile-group {
		width:60%;
	}
	#${name}_other-group {
		width:40%;
	}
	#${name}_other-group .fieldrow_label  {
		width:86px;
		margin-right:0px;
	}
	#${name}_optInEmail-group .fieldrow_value {
		margin-top:10px;
	}
	.health .error .refineSearch {
		text-decoration:underline;
		cursor:pointer;
	}
	.health_application-details_contact-group {
		display:none;
	}
	.health_application_contactPoint-group .fieldrow_value {
		margin-top:7px;
	}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var healthApplicationDetails = {
		periods: 1,
		init: function(){
			this.setPostal();
			$('#${name}_postalMatch').on('change', function(){
				healthApplicationDetails.setPostal();
			});
		},
		setPostal: function(){
			if( $('#${name}_postalMatch').is(':checked')  ){
				$('#${name}_postalGroup').slideUp();
			} else {
				$('#${name}_postalGroup').slideDown();
			};
		},
		<%-- this is called to populate the price premiums just before the application is submtted --%>
		setFinalPremium: function(){
			$('#${name}_paymentAmt').val( healthApplicationDetails.premium * healthApplicationDetails.periods);
			$('#${name}_paymentFreq').val( healthApplicationDetails.premium);
		}
	};
	
$.validator.addMethod("oneContact",
	function(value, element) {
		
		if( $('#${name}_mobile').val() + $('#${name}_other').val() == '' ){
			return false;
		} else {
			return true;
		};
		
	},
	"Custom message"
);

$.validator.addMethod("matchStates",
	function(value, element) {
		if( $(element).val() !== $('#mainform').find('.health-situation-state').find(':selected').val() ){
			$('#${name}_address_postCode').addClass('error');
			return false;
		} else {
			return true;
		};		
	},
	"Your address does not match the original state provided"
);	
</go:script>

<go:script marker="onready">

	$.address.internalChange(function(event){
		if(event.parameters.stage == 3)
		{
			var email = $("#${field_email}").val();
			
			if(!email.length) {
				$("#${field_email}").val( $("#health_contactDetails_email").val() );
			}
		}
	});

	healthApplicationDetails.init();
	
	$('#${name}_address_state').addClass('validate');
	
	<%-- Go back to the start of the application question set, due to a 'fatal' type error --%>
	$('#slideErrorContainer').delegate('.refineSearch', 'click', function() {
		Results.startOver();
	});
	
	$(function() {
		$('#${name}_contactPoint-group').buttonset();
	});
		
	$('#${field_mobile}, #${name}_other').on('blur', function(){
		healthChoices.setContactNumberReverse();
	});
		
</go:script>

<go:validate selector="${name}_mobileinput" rule="oneContact" parm="true" message="Please include at least one number" />
<go:validate selector="${name}_address_state" rule="matchStates" parm="true" message="Your address does not match the original state provided. You can <span class='refineSearch'>refine your search</span> by changing the original state." />