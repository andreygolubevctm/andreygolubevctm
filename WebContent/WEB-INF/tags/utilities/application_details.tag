<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
			<field:array_select items="=Please choose...,Mr=Mr,Mrs=Mrs,Miss=Miss,Ms=Ms,Cr=Cr,Prof=Prof" xpath="${xpath}/title" title="your title" required="true" />
		</form:row>
		
		<form:row label="First name">
			<field:input xpath="${xpath}/firstName" title="First name" required="true" maxlength="50"/>
		</form:row>
		
		<form:row label="Last name">
			<field:input xpath="${xpath}/lastName" title="Last name" required="true" maxlength="50"/>
		</form:row>
		
		<form:row label="Date of birth">
			<field:date_text_entry xpath="${xpath}/dob" title="birth" required="true" />
		</form:row>
		
		<form:row label="Mobile number">
			<field:contact_mobile xpath="${xpath}/mobileNumber" required="false" />
		</form:row>
		
		<form:row label="Other phone number">
			<field:contact_telno xpath="${xpath}/otherPhoneNumber" required="false" title="another phone number"/>
		</form:row>
		
		<form:row label="Email address">
			<field:contact_email xpath="${xpath}/email" required="true" title="your email address" />
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
		
		<form:row label="Situation" id="situationRow">
			<field:array_radio items="Y=I need to set up energy accounts as I am going to move to this property (or have recently moved in and not set set up accounts),N=I am already living at this address and want to change my energy company" xpath="${xpath}/movingIn" title="if you are moving to this property" required="true" className="" id="${name}_movingIn" />
		</form:row>
		
		<div id="movingDateContainer">
			<h5>Move-in details</h5>
			
			<form:row label=" ">
				<div id="${name}_moveInDetails">
				
					<div id="${name}_moveInDetails_placeholder"></div>
					
					<core:js_template id="move-in-details-template">
						<p>As you are moving in to the above address, please enter below the date on which you wish to have the electricity/gas supply connected.</p> 
						<p>You must provide at least [#= business_days #] business days' notice prior to your move-in date or you risk not having your supply connected in time.</p>
						<p>Please note that suppliers can only arrange connections on weekdays (Mon-Fri), excluding public holidays.</p>
						<p>You will need to contact your current supplier(s) to arrange disconnection at the home you are leaving.</p>
					</core:js_template>
				</div>
			</form:row>
			
			<form:row label="Move in date">
				<field:basic_date xpath="${xpath}/movingDate" title="moving date" required="true" disableWeekends="true" maxDate="+60d" />
			</form:row>
			<form:row label=" ">
				<p id="${name}_movingDateLabel">Please ensure that there is access to your meter at all times on the proposed day of connection.</p>
			</form:row>
		</div>
		
		<div id="noVisualInspectionAppointmentContainer">
			<form:row label=" ">
				If a visual inspection of your meter is required, <span class="providerName"></span> will contact you to arrange this.
			</form:row>
		</div>
		
		<div id="isPowerOnContainer">
			<form:row label="Is the power on at your new property?">
				<field:array_radio items="Y=Yes,N=No" id="${name}_isPowerOn" xpath="${xpath}/isPowerOn" title="if the power is on at your property" required="true" />
			</form:row>
		</div>
		
		<div id="visualInspectionAppointmentContainer">
			<form:row label=" ">
				You have indicated that your property has no power. An Energex representative might be required to visit your property on your move in date to reconnect your power supply. During this visit, someone over the age of 18 will be required at the property. Please choose your preferred appointment time below.
			</form:row>
			<form:row label="Visual Inspection Appointment">
				<field:array_select items="=Please choose...,Time8amTo1pm=From 8am to 1pm,Time1pmTo6pm=From 1pm to 6pm" xpath="${xpath}/visualInspectionAppointment" title="visual inspection appointment" required="true" />
			</form:row>
		</div>
		
	</form:fieldset>		

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} #isPowerOnContainer,
	#${name} #visualInspectionAppointmentContainer,
	#${name} #noVisualInspectionAppointmentContainer{
		display: none;
	}
	#${name}_movingIn,
	#${name}_movingDateLabel,
	#${name}_moveInDetails,
	#${name} #situationRow .fieldrow_value,
	#${name} #visualInspectionAppointmentContainer .fieldrow_value,
	#${name} #noVisualInspectionAppointmentContainer .fieldrow_value{
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
			
			$('#${name}_isPowerOn').buttonset();
			$('#${name}_address_state').addClass('validate');
			
			<%-- Go back to the start of the application question set, due to a 'fatal' type error --%>
			$('#slideErrorContainer').delegate('.refineSearch', 'click', function() {
				$('#slideErrorContainer').hide();
				$('.right-panel').not('.slideScrapesContainer').show();
				QuoteEngine.gotoSlide({
					index:	0
				});
			});
			
			utilitiesApplicationDetails.setPostal();
			$('#${name}_postalMatch').on('change', function(){
				utilitiesApplicationDetails.setPostal();
			});
			
			utilitiesApplicationDetails.setMovingIn();
			$('#${name}_movingIn').on('change', function(){
				utilitiesApplicationDetails.setMovingIn();
			});
			
		},
		
		setPostal: function(){
			if( $('#${name}_postalMatch').is(':checked')  ){
				$('#${name}_postalGroup').slideUp();
			} else {
				$('#${name}_postalGroup').slideDown();
			};
		},
		
		setMovingIn: function(){
		
			if( $('#${name}_movingIn :checked').val() == 'Y' ){
				$("#movingDateContainer").slideDown();
				$("#utilities_application_thingsToKnow_transferChkTransferTitle").hide();
				$("#utilities_application_thingsToKnow_transferChkMoveInTitle").show();
			}else {
				$("#movingDateContainer").slideUp();
				$("#utilities_application_thingsToKnow_transferChkTransferTitle").show();
				$("#utilities_application_thingsToKnow_transferChkMoveInTitle").hide();
			}
			
			utilitiesChoices.showHideisPowerOn();
			
		}
	};
	
	$.validator.addMethod("notMobile",
		function(value, element) {
			if($(element).val().substring(0,2) == '04'){
				return false;
			} else {
				return true;
			};
			
		},
		"Custom message"
	);
	
	$.validator.addMethod("matchStates",
		function(value, element) {
			if( $(element).val() !== utilitiesChoices._state ){
				$('#${name}_address_postCode').addClass('error');
				return false;
			} else {
				return true;
			};		
		},
		"Your address does not match the original state provided"
	);	
	
	$.validator.addMethod("validateMobileField",
		function(value, element) {
			var mobileField = $('#${name}_mobileNumber');
			var phoneField = $('#${name}_otherPhoneNumber'); 
			
			$("#${name}_mobileNumberinput, #${name}_otherPhoneNumber").on("change", function(){
				$("#${name}_mobileNumberinput, #${name}_otherPhoneNumberinput").valid();
			});
			
			mobileField.val( String($(element).val()).replace(/[^0-9]/g, '') );
			
			var mobile = mobileField.val();
			var phone = phoneField.val();
			
			if(mobile != '' && mobile.substring(0,2) == '04'){
				return true;
			} else {
				return phone != '';
			};
			
		},
		"Custom message"
	);
	
	$.validator.addMethod("validatePhoneField",
		function(value, element) {
			var phone = $('#${name}_otherPhoneNumber').val();
			var mobile = $('#${name}_mobileNumber').val();
			
			if(phone != '' && phone.substring(0,2) != '04'){
				return true;
			} else if(phone != '' && phone.substring(0,2) == '04') {
				return false;
			} else {
				return true;
			};
			
		},
		"Custom message"
	);
</go:script>

<go:script marker="onready">	

	utilitiesApplicationDetails.init();
	
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_mobileNumberinput" rule="validateMobileField" parm="true" message="You need to provide a mobile number or a landline number." />
<go:validate selector="${name}_otherPhoneNumber" rule="validatePhoneField" parm="true" message="The 'Other phone number' cannot be a mobile number." />
<go:validate selector="${name}_address_state" rule="matchStates" parm="true" message="Your address does not match the original state provided. You can <span class='refineSearch'>refine your search</span> by changing the original state." />

<jsp:useBean id="now" class="java.util.GregorianCalendar" scope="page" />
<% now.add(java.util.GregorianCalendar.YEAR, -18); %>
<fmt:formatDate value="${now.time}" pattern="dd/MM/yyyy" var="maxDate" />
<go:validate selector="${name}_dob" rule="maxDateEUR" parm="'${maxDate}'" message="You need to be 18 years of age or older to switch your energy services"/>