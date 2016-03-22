<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="required" 	required="false"	 rtexprvalue="true"	 description="whether its required" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"	value="${go:nameFromXpath(xpath)}_call" />
<c:set var="brandedName"><content:optin key="brandDisplayName" useSpan="true"/></c:set>

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionEnabled" value="${competitionEnabledSetting == 'Y'}" />

<%-- Wrap this declaration with a <c:choose /> if you need to add split testing functionality to this page --%>
<%-- Standard journey --%>
<c:set var="splitTestingJourney" value="0" />

<form_v2:fieldset_columns sideHidden="false">

	<jsp:attribute name="rightColumn">
	</jsp:attribute>

	<jsp:body>
		<form_v1:fieldset legend="Contact Details">

			<form_v2:row label="Email Address" id="contactEmailRow">
				<field_v2:email xpath="${xpath}/contactDetails/email" required="true" title="your email address" additionalAttributes=" data-rule-validateOkToEmail='true' " /><span id="email_note">For confirming quote and transaction details</span>
			</form_v2:row>

			<c:set var="fieldXPath" value="${xpath}/contactDetails/contactNumber" />
			<form_v2:row label="Phone Number" id="contactNoRow">
				<field_v1:flexi_contact_number xpath="${fieldXPath}"
											   maxLength="20"
											   id="bestNumber"
											   required="false"
											   labelName="phone number"
											   validationAttribute=" data-rule-validateOkToCall='true' "/>
			</form_v2:row>

			<c:set var="fieldXpath" value="${xpath}/primary/postCode"/>
			<form_v2:row fieldXpath="${fieldXpath}" label="Postcode" id="${name}_postCode_suburb" className="${name}_nonStdFieldRow">
				<field_v1:post_code xpath="${fieldXpath}" required="true" title="postcode" additionalAttributes="${postCodeNameAdditionalAttributes}"/>
			</form_v2:row>

			<%-- COMPETITION START --%>
			<c:if test="${competitionEnabled == true}">
				<c:set var="competitionId"><content:get key="competitionId"/></c:set>
				<form_v1:row label="" className="promo-row">
					<div class="promo-container">
						<div class="promo-image life-${competitionId}"></div>
					</div>
				</form_v1:row>

				<form_v1:row label="" className="clear">
					<c:set var="competitionCheckboxText">
						<content:get key="competitionCheckboxText" />
					</c:set>
					<field_v2:checkbox xpath="${xpath}/competition/optin" value="Y" title="${competitionCheckboxText}" label="true" required="false"/>
					<field_v1:hidden xpath="${xpath}/competition/previous" />
				</form_v1:row>
			</c:if>
			<%-- COMPETITION END--%>

			<form_v1:row label="" className="clear">
				<field_v2:checkbox xpath="${xpath}/optin" value="Y" title="I agree to receive news &amp; offer emails from ${brandedName}" label="true" required="false"/>
			</form_v1:row>

			<form_v1:row label="" className="clear closer">
				<c:set var="label_text">
					I understand ${brandedName} compares life insurance policies from a range of <a href="javascript:;" class="suppliersMoreInfo">participating suppliers</a>. By entering my telephone number I agree that Lifebroker and/or Auto and General Services, Compare the Market&#39;s trusted life insurance partners may contact me to further assist with my life insurance needs. I confirm that I have read the <a href="javascript:;" class="privacyStatementMoreInfo">privacy statement</a>.
				</c:set>

				<field_v2:checkbox xpath="${xpath}_privacyoptin" value="Y" title="${label_text}" errorMsg="Please confirm you have read the privacy statement" label="true" required="true"/>
			</form_v1:row>

			<field_v1:hidden xpath="${xpath}/call" />
			<field_v1:hidden xpath="${xpath}/splitTestingJourney" constantValue="${splitTestingJourney}" />

		</form_v1:fieldset>
	</jsp:body>
</form_v2:fieldset_columns>

<c:set var="brandedName"><content:optin key="brandDisplayName" useSpan="true"/></c:set>
<c:set var="participatingSuppliers"><content:get key="participatingSuppliers" /></c:set>
<core_v1:js_template id="participatingSuppliers">
	${brandedName}&nbsp;&nbsp;${participatingSuppliers}
</core_v1:js_template>

<core_v1:js_template id="privacyStatement">
	<content:get key="privacyStatement" /><a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank">View Privacy Policy</a>
</core_v1:js_template>


<%-- CSS
<go:style marker="css-head">
	.state-right:after {
		margin-top: 6px;
		position: absolute;
	}

	#${name} .fieldrow_legend {
		float:		right;
		width:		125px;
		margin: 	4px 0px 0px 3px;
		font-size:	95%;
	}
	#${name}_call {
			float:left;
		}
	.${name}_call {
			width: 400px;
			margin-left: 207px;
	}
	.${name}_contact_agree {
			margin-top: 20px;
	}

	#${name}_email {
		float: left;
		margin-right: 0.4em;
	}
	#${name}-selection .clear { clear:both; }
	.life-contact-details-call-group { min-height:0; }
	.life-contact-details-call-group .fieldrow_value {padding-top:5px !important;}

	#email_note {
		width: 120px;
		float: right;
		font-size: 10px;
		color: #747170;
		padding-left: 10px;
		margin-top: 5px;
	}

	.email-row .fieldrow_value {
		width: 410px;
	}

	.fieldrow_value {
		max-width: 410px;
		margin-bottom: 10px;
	}
</go:style>

<%-- JAVASCRIPT
<go:script marker="onready">
	$(function() {
		$("#${name}_call").buttonset();
	});

	$("#${name}_optIn").parent().css({marginRight:'-5px'});

	${name}_original_phone_number = $('#${contactNumber}').val();

	$('#${optIn}').val( $('#${contactNumber}').val().length ? 'Y' : 'N');

	$('#${contactNumber}input').on('update keypress blur', function(){

		var tel = $(this).val();

		$('#${optIn}').val( tel.length && tel != $(this).attr('placeholder') ? 'Y' : 'N' );

		if(!tel.length || ${name}_original_phone_number != tel){
			$('#${name}_call').find('label[aria-pressed="true"]').each(function(key, value){
				$(this).attr("aria-pressed", "false");
				$(this).removeClass("ui-state-active");
				$('#' + $(this).attr("for")).removeAttr("checked");
			});
		};

		${name}_original_phone_number = tel;
	});
	
	<c:if test="${competitionEnabled eq true}">
		$('#${vertical}_contactDetails_competition_optin[type="checkbox"]').on('change', function(e){
			if(this.checked) {
				<%-- 
					Opt In -- Unset phone number as mandatory field 
				--%
				$('#${vertical}_contactDetails_contactNumberinput').attr('required', 'required').addClass('state-force-validate');
			} else {
				<%-- 
					Opt Out -- Unset phone number as mandatory field
				--%
				$('#${vertical}_contactDetails_contactNumberinput').attr('required', false).removeClass('error');
				$('#mainform').validate().element('#${vertical}_contactDetails_contactNumberinput');
			}
		});
	</c:if>

	<c:if test="${empty callCentre}">
		if( String($('#${contactNumber}').val()).length ) {
			$('#${contactNumber}input').trigger("blur");
		}
	</c:if>

	slide_callbacks.register({
		direction:	"reverse",
		slide_id:	0,
		callback: 	function() {
			$.validator.prototype.applyWindowListeners();
		}
	});

	$('#${name}_optIn').change(function() {
		$(document).trigger(SaveQuote.setMarketingEvent, [$(this).attr('checked'), $('#${name}_email').val()]);
	});
	$('#${name}_email').change(function() {
		$(document).trigger(SaveQuote.setMarketingEvent, [$('#${name}_optIn').attr('checked'), $(this).val()]);
	});
</go:script>
--%>

