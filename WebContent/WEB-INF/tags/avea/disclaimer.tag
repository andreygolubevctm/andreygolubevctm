<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<field:hidden xpath="quote/avea/leadNo"></field:hidden>

<form:fieldset legend="The insurer needs a little more information in order to confirm the quote value">
	<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
		<form:row className="widest_label" label="Please note that the answers to the questions below are subject to AutObarn's underwriting criteria. Certain answers to these questions may affect the acceptance of cover, increase the premium or increase the excess charged."></form:row>
	</c:if>
	<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
		<form:row className="widest_label" label="Please note that the answers to the questions below are subject to carsure.com.au's underwriting criteria. Certain answers to these questions may affect the acceptance of cover, increase the premium or increase the excess charged."></form:row>
	</c:if>
	<core:clear/>
	<c:if test="${param.prdId != null && param.prdId == 'aubn'}">
		<field:checkbox xpath="quote/avea/agreeDisclosures" className="ml18" value="1" title="Agree to Disclosure Statements" required="true"></field:checkbox>I have read and understand AutObarn's <a href="javascript:;" class="avea_dod">Duty of Disclosure</a> and <a href="javascript:showDoc('http://www.avea.com.au/PDS/MOT_Unbranded.pdf');">Product Disclosure Statement</a>		
	</c:if>
	<c:if test="${param.prdId != null && param.prdId == 'crsr'}">
		<field:checkbox xpath="quote/avea/agreeDisclosures" className="ml18" value="1" title="Agree to Disclosure Statements" required="true"></field:checkbox>I have read and understand carsure.com.au's <a href="javascript:;" class="avea_dod">Duty of Disclosure</a> and <a href="javascript:showDoc('http://www.avea.com.au/PDS/MOT_Unbranded.pdf');">Product Disclosure Statement</a>		
	</c:if>
</form:fieldset>


<c:if test="${data['quote/vehicle/modifications'] == 'Y'}">
	<form:fieldset legend="Additional Car Details">
		<avea:additional_car_details xpath="quote/avea/modifications" />
		<core:clear />
	</form:fieldset>
</c:if>


<form:fieldset legend="Provide the details of the regular driver">
	<avea:additional_driver countId="driver0" hideSeparator="true" xpath="quote/avea/driver0" />
	<core:clear />
</form:fieldset>


<form:fieldset legend="Additional Drivers">
	<avea:additional_rows_yesno title="Additional Drivers" 
			countIds="driver1,driver2,driver3,driver4,driver5" 
			required="true" 
			xpath="quote/avea/drivers/additional" 
			id="additional_drivers" 
			className="widest_label" 
			heading="Are there any other drivers you wish to add?" 
			tagPath="avea:additional_driver" />
	<core:clear />
</form:fieldset>


<form:fieldset legend="Incidents and Claims History">
	<strong>In the last 5 years, have you or anyone who is likely to drive the car;</strong>
	
	<avea:additional_rows_yesno title="Motoring Offences" 
			countIds="motoringOffences0,motoringOffences1,motoringOffences2,motoringOffences3,motoringOffences4" 
			required="true" 
			xpath="quote/avea/incidentsClaimsOther/motoringOffences" 
			id="motoringOffences" 
			className="widest_label" 
			heading="Been charged or convicted or issued an infringement notice for any motoring offence?" 
			tagPath="avea:additional_motoringoffences" helpId="220" />
			
	<avea:additional_rows_yesno title="Stolen, damaged, destroyed" 
			countIds="accidents0,accidents1,accidents2,accidents3,accidents4" 
			required="true" 
			xpath="quote/avea/incidentsClaimsOther/accidents" 
			id="accidents" 
			className="widest_label" 
			heading="Had an at fault accident with a car or had a car stolen, damaged (including hail) or destroyed by fire?" 
			tagPath="avea:additional_accidents" helpId="221" />
			
	<avea:additional_rows_yesno title="Licence refused, suspended, cancelled or endorsed" 
			countIds="licenseEndorsements0,licenseEndorsements1,licenseEndorsements2,licenseEndorsements3,licenseEndorsements4" 
			required="true" 
			xpath="quote/avea/incidentsClaimsOther/licenseEndorsements" 
			id="licenseEndorsements" 
			className="widest_label" 
			heading="Had their driving licence refused, suspended, cancelled or endorsed (includes and good behaviour periods)?" 
			tagPath="avea:additional_licenseendorsements" helpId="222" />
	<core:clear />
	
</form:fieldset>


<form:fieldset legend="Other Information">
	<strong>Have you or anyone who is likely to drive the car;</strong>
	
	<avea:additional_rows_yesno title="Been charged or convicted" 
			countIds="criminalConvictions0,criminalConvictions1,criminalConvictions2,criminalConvictions3,criminalConvictions4" 
			required="true" 
			xpath="quote/avea/incidentsClaimsOther/criminalConvictions" 
			id="criminalConvictions" 
			className="widest_label" 
			heading="Been charged or convicted of a criminal offence?" 
			tagPath="avea:additional_criminalconvictions" helpId="223" />

	<avea:additional_rows_yesno title="Policy refused, denied, cancelled" 
			countIds="insuranceRefused0,insuranceRefused1,insuranceRefused2,insuranceRefused3,insuranceRefused4" 
			required="true" 
			xpath="quote/avea/incidentsClaimsOther/insuranceRefused" 
			id="insuranceRefused" 
			className="widest_label" 
			heading="Had an insurance policy refused, denied, cancelled or special conditions applied or excess imposed by an insurer?" 
			tagPath="avea:additional_insurancerefused" helpId="224" />
	<core:clear />
	
</form:fieldset>

<c:if test="${data['quote/vehicle/modifications'] != 'Y'}">
	<form:fieldset legend="Please enter the cars' registration number">
		<form:row label="Car Registration Number" className="wide_label">
			<field:input_alphanumeric xpath="quote/avea/regoNumber" maxlength="10" title="Car Registration Number" required="true"></field:input_alphanumeric>
		</form:row>
		<core:clear />
	</form:fieldset>
</c:if>
 


<field:hidden xpath="quote/avea/productId" defaultValue="${param.prdId}" constantValue="${param.prdId}" />

<core:clear />


<%-- CSS STYLES --%>
<go:style marker="css-head">
	#quote_avea_regoNumber{text-transform:uppercase;}
</go:style>

<%-- JAVASCRIPT ONREADY --%>
<go:script marker="onready">
	
	<%-- Default page manipulations --%>
	$('#quote_avea_premiumType_CreditCardInFull').attr('checked', true);
	//$('#exit-quote').hide();
	$('#prev-step').css({'background-image':'url("/cc/common/images/button-back.png")'})
	
	<%-- JQuery Assignments --%>
	$('.kilometres_driven').numeric();
	$('.first_year_licenced').numeric();
	$('.demerit_points').numeric();
	$('.amount_damage').numeric();
	$('.driver_first_name').blur(function(){ popupateDriverDropdowns(); });
	$('.avea_dod').click(function(){ DisclosurePopup.show() });
	$('.avea_pds').click(function(){ ProductDisclosurePopup.show() });
	$('.avea_cpp').click(function(){ CarsureprivacyPopup.show() });
	$('.avea_cst').click(function(){ CarsuretermsPopup.show() });
	
	<%-- Force Uppercase --%>
	$('#quote_avea_payment_cardName').blur(function(){
		$('#quote_avea_payment_cardName').val( $('#quote_avea_payment_cardName').val().toUpperCase() );
	});
	
	<%-- Sanitize Car Rego --%>
	$('#quote_avea_regoNumber').keyup(function(){
		$('#quote_avea_regoNumber').val( $('#quote_avea_regoNumber').val().toUpperCase() );
	});
	
	<%-- Sanitize KM Driven --%>
	$('.kilometres_driven').keyup(function(){
		$('.kilometres_driven').each(function(){
			$(this).val(Math.round($(this).val()));
		});
	});
	
	<%-- Handle Yes/No radio buttons for 'additional drivers' --%>
	$("#quote_avea_drivers_additional_Y, #quote_avea_drivers_additional_N").change(function(){
		toggle_drivers(); 
	});
	$('#add_driver_driver0').click(function(){
		$("[for='quote_avea_drivers_additional_Y']").click(); 
		re_show_links('driver_driver1');
	});
	
	<%-- Buttonize the radios --%>
	$("#additional_drivers, #motoringOffences, #accidents, #licenseEndorsements, #criminalConvictions, #insuranceRefused").buttonset();
	

</go:script>







