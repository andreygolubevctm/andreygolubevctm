<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Application Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Your Details">
		
		<form:row label="Title">
			<field:array_select items="=Please choose...,Mr=Mr,Mrs=Mrs,Miss=Miss,Ms=Ms,Dr=Dr,Prof=Prof" xpath="${xpath}/title" title="your title" required="true" />
		</form:row>
		
		<form:row label="First name">
			<field:person_name xpath="${xpath}/firstName" title="First name" required="true" maxlength="50"/>
		</form:row>
		
		<form:row label="Last name">
			<field:person_name xpath="${xpath}/lastName" title="Last name" required="true" maxlength="50"/>
		</form:row>
		
		<form:row label="Date of birth">
			<field:person_dob xpath="${xpath}/dob" ageMin="0" ageMax="99" title="birth" required="true" />
		</form:row>
		
		<form:row label="Mobile number">
			<field:contact_mobile xpath="${xpath}/mobileNumber" required="false" />
		</form:row>
		
		<form:row label="Other phone number">
			<field:contact_telno xpath="${xpath}/otherPhoneNumber" required="false" title="other phone number" isLandline="true" />
		</form:row>
		
		<form:row label="Email address">
			<field:contact_email xpath="${xpath}/email" required="true" title="your email address" />
			
			<div id="secondOptIn_chk_container">			
				<field:checkbox
					xpath="${xpath}/receiveInfoCheck"
					value="Y"
					title="I would like to receive electronic communication from <strong>compare</strong>the<strong>market</strong>.com.au"
					required="false"
					label="true" />
			</div>
		</form:row>
		
		

		<h5>Residential Address</h5>
		<group:address xpath="${xpath}/address" type="R" />
		<core:clear />
		
		<%-- POSTAL defaults to Y if not pre-loaded --%>
		<c:if test="${empty data[xpath].postalMatch}">
			<go:setData dataVar="data" xpath="${xpath}/postalMatch" value="Y" />
		</c:if>	
		
		<h5>Postal Address</h5>
		<form:row label=" " >		
			<field:checkbox xpath="${xpath}/postalMatch" value="Y" title="My postal address is the same" required="false" label="I agree to receive news &amp; offer emails from Compare the Market" />
		</form:row>
		
		<div id="${name}_postalGroup">			
			<group:address xpath="${xpath}/postal" type="P" />
		</div>
		
		<div id="movingDateContainer">
			<form:row label="Move in date">
				<field:basic_date xpath="${xpath}/movingDate" title="moving date" required="true" disableWeekends="true" maxDate="+60d" />
			</form:row>
		</div>
		
	</form:fieldset>
		
		</div>
		
		

<%-- CSS --%>
<go:style marker="css-head">
	#${name}_movingIn,
	#${name}_movingDateLabel,
	#${name}_moveInDetails,
	#${name} #situationRow .fieldrow_value,{
		width: 400px;
		max-width: 400px;
	}


	#${name} #situationRow input{
		float: left;
		clear: left;
	}
	#${name} #situationRow label{
		float: left;
		width: 374px;
		font-size: 100%;
		line-height: normal;
		padding-left: 5px;
		margin-bottom: 5px;
	}
	
	#${name} #movingDateContainer{
		zoom: 1;
		min-height:0;
	}
	.utilities .error .refineSearch {
		text-decoration: underline;
		cursor: pointer;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var utilitiesApplicationDetails = {
		init: function(){
			
			$('#${name}_address_state').addClass('validate');
			
			<%-- Go back to the start of the application question set, due to a 'fatal' type error --%>
			$('#slideErrorContainer').delegate('.refineSearch', 'click', function() {
				$('#slideErrorContainer').hide();
				$('.right-panel').not('.slideScrapesContainer').show();
				QuoteEngine.gotoSlide({
					index:	0
				});
			});
			
			postalMatchHandler.init('${name}');
			
			utilitiesApplicationDetails.setMovingIn();

			utilitiesApplicationDetails.setOptIn();
			$('#utilities_application_details_email').on('change', function(){
				utilitiesApplicationDetails.setOptIn();				
			});
			
			$('#utilities_application_details_receiveInfoCheck').on('click', function(){
				utilitiesApplicationDetails.setOptInValue();				
			});

			

			template = $("#terms-template").html();
			// Terms  conditions template
			//return $(parseTemplate( template, product ) );
		},
		
		setMovingIn: function(){
		
			if( $("input[name='utilities_householdDetails_movingIn']:checked").val() == 'Y' ){
				$("#movingDateContainer").show();
			}else {
				$("#movingDateContainer").hide();
			}
			
		},
			
		setOptIn:function(){
			if($("#utilities_resultsDisplayed_email").val() != $("#utilities_application_details_email").val()){
				$("#secondOptIn_chk_container").show();
				$("#utilities_application_thingsToKnow_receiveInfo").val("N");
				$("#utilities_application_details_receiveInfoCheck").removeAttr("checked");
			}else{
				$("#secondOptIn_chk_container").hide();
				$("#utilities_application_thingsToKnow_receiveInfo").val("Y");
		}
		},

		setOptInValue:function(){
			if( $("#utilities_application_details_receiveInfoCheck:checked").val() == 'Y' ){
				$("#utilities_application_thingsToKnow_receiveInfo").val("Y");
			}else {
				$("#utilities_application_thingsToKnow_receiveInfo").val("N");
			}
		}


	};
	

	



	


</go:script>

<go:script marker="onready">	

	utilitiesApplicationDetails.init();
	
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_mobileNumberinput" rule="validateMobileField" parm="true" message="You need to provide a mobile number or a landline number." />
<go:validate selector="${name}_address_state" rule="matchStates" parm="true" message="Your address does not match the original state provided. You can <span class='refineSearch'>refine your search</span> by changing the original state." />

<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<% now.add(java.util.GregorianCalendar.YEAR, -18); %>
<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="maxDate" />
<go:validate selector="${name}_dob" rule="maxDateEUR" parm="'${maxDate}'" message="You need to be 18 years of age or older to switch your energy services"/>