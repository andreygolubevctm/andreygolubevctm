<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>
<%@ attribute name="required" 	required="false"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumberinput" />


<%-- HTML --%>
<div id="${name}-selection" class="health-your_details">

	<form:fieldset legend="Your Contact Details" >

		<form:row label="First name" className="halfrow">
			<field:input xpath="${xpath}/firstName" title="first name" required="${callCentre}" size="13" />
		</form:row>

		<form:row label="Surname" className="halfrow right">
			<field:input xpath="${xpath}/lastname" title="last name" required="false" size="13" />
		</form:row>

		<form:row label="Your email address" className="clear">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="${not callCentre}" />
		</form:row>

		<form:row label="Your mobile number">
			<field:contact_mobile xpath="${xpath}/contactNumber" required="false" className="contact_number" />
		</form:row>
		
		<%-- Optional question for users - mandatory if Contact Number is selected (Required = true as it won't be shown if no number is added) --%>
		<c:choose>
			<c:when test="${empty callCentre}">
				<form:row label=" " className="health-contact-details-call-group">
					<field:checkbox xpath="${xpath}/call" value="Y" title="I understand comparethemarket.com.au compares health insurance policies from a range of <a href='http://www.comparethemarket.com.au/health-insurance/#tab_nav_1432_0' target='_blank'>participating suppliers</a>. By entering my telephone number I agree that comparethemarket.com.au may contact me to further assist with my health insurance needs" required="true" label="I understand comparethemarket.com.au compares health insurance policies from a range of <a href='http://www.comparethemarket.com.au/health-insurance/#tab_nav_1432_0' target='_blank'>participating suppliers</a>. By entering my telephone number I agree that comparethemarket.com.au may contact me to further assist with my health insurance needs" errorMsg="Please agree to the Terms &amp; Conditions" />				
				</form:row>
			</c:when>
			<c:otherwise>
				<field:hidden xpath="${xpath}/call" />		
			</c:otherwise>
		</c:choose>
	
	</form:fieldset>

</div>


<%-- CSS --%>
<go:style marker="css-head">
	#${name}_call {
		float:left;
	}
	.health-contact-details-call-group label {
		float:right;
		max-width:350px;
		margin-left:1em;
	}
	#${name}-selection .clear { clear:both; }
		.health-contact-details-call-group { min-height:0; }
		.health-contact-details-call-group .fieldrow_value {padding-top:5px !important;}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#${name}_call").buttonset();
	});
	
	${name}_original_phone_number = $('#${contactNumber}').val();

	$('#${contactNumber}').on('update keypress blur', function(){
	
		var tel = $(this).val();
		/*if(tel.length){
			$('#${name}-selection').find('.health-contact-details-call-group').not(":visible").slideDown();
		}*/
		
		if(!tel.length || ${name}_original_phone_number != tel){
			$('#${name}_call').find('label[aria-pressed="true"]').each(function(key, value){
				$(this).attr("aria-pressed", "false");
				$(this).removeClass("ui-state-active");
				$('#' + $(this).attr("for")).removeAttr("checked");
			});
			
			/*if(!tel.length) {				
				$('#${name}-selection').find('.health-contact-details-call-group').slideUp();
			}*/
		};
		
		${name}_original_phone_number = tel;
	});
	
	$('#${contactNumber}').on('blur change', function(){
		healthChoices.setContactNumber();
	});
	
<c:if test="${empty callCentre}">	
	if( String($('#${contactNumber}').val()).length ) {
		$('#${contactNumber}').trigger("blur");
	}
</c:if>

	slide_callbacks.register({
		direction:	"reverse",
		slide_id:	1,
		callback: 	function() {
			$.validator.prototype.applyWindowListeners();
		}
	});
</go:script>

<%-- VALIDATION --%>