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
		
		<form:row label="Situation">
			<field:array_select items="Y=I need to set up energy accounts as I am going to move to this property (or have recently moved in and not set set up accounts),N=I am already living at this address and want to change my energy company" xpath="${xpath}/movingIn" title="if you are moving to this property" required="true" className="" />
		</form:row>
		
		<div id="movingDateContainer">
			<form:row label="Moving Date">
				<field:basic_date xpath="${xpath}/movingDate" title="the moving date" required="true" options="beforeShowDay: $.datepicker.noWeekends" />
			</form:row>
		</div>
		
		<div id="isPowerOffContainer">
			<form:row label="Is the power currently off?">
				<field:array_radio items="Y=Yes,N=No" id="${name}_isPowerOff" xpath="${xpath}/isPowerOff" title="if the power is off" required="true" />
			</form:row>
		</div>
		
		<div id="visualInspectionAppointmentContainer">
			<form:row label="Visual Inspection Appointment">
				<field:array_select items="=Please choose...,Time8amTo1pm=From 8am to 1pm,Time1pmTo6pm=From 1pm to 6pm" xpath="${xpath}/visualInspectionAppointment" title="visual inspection appointment" required="true" />
			</form:row>
		</div>
		
	</form:fieldset>		

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} #isPowerOffContainer,
	#${name} #visualInspectionAppointmentContainer{
		display: none;
	}
	#${name}_movingIn{
		width: 400px;
		max-width: 400px;
		position: absolute;
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
			
			$('#${name}_isPowerOff').buttonset();
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
			
			$('select#${name}_movingIn').ieSelectWidth();
					
			
		},
		
		setPostal: function(){
			if( $('#${name}_postalMatch').is(':checked')  ){
				$('#${name}_postalGroup').slideUp();
			} else {
				$('#${name}_postalGroup').slideDown();
			};
		},
		
		setMovingIn: function(){
		
			if( $('#${name}_movingIn').val() == 'Y' ){
				$("#movingDateContainer").slideDown();
			}else {
				$("#movingDateContainer").slideUp();
			}
			
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
	
	$.validator.addMethod("notWeekends",
		function(value, element) {
			
			return $.datepicker.noWeekends($(element).datepicker("getDate"))[0];
			
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
			var mobile = $('#${name}_mobileNumber').val();
			var phone = $('#${name}_otherPhoneNumber').val();
			
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
<go:validate selector="${name}_movingDate" rule="notWeekends" parm="true" message="The moving date has to be a business day (ie. not on the weekend)" />
<go:validate selector="${name}_address_state" rule="matchStates" parm="true" message="Your address does not match the original state provided. You can <span class='refineSearch'>refine your search</span> by changing the original state." />
