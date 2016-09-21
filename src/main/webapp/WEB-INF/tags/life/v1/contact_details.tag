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

<c:set var="vertical">
	<c:choose>
		<c:when test="${fn:startsWith(name, 'life_')}">life</c:when>
		<c:otherwise>ip</c:otherwise>
	</c:choose>
</c:set>

<c:set var="competitionEnabledSetting"><content:get key="competitionEnabled"/></c:set>
<c:set var="competitionEnabled" value="${competitionEnabledSetting == 'Y'}" />

<%-- Wrap this declaration with a <c:choose /> if you need to add split testing functionality to this page --%>
<%-- Standard journey --%>
<c:set var="splitTestingJourney" value="0" />


<%-- HTML --%>
<div id="${name}-selection" class="${name}">
	<form_v1:fieldset legend="Contact Details">
		<form_v1:row label="Email address" className="clear email-row">
			<field_v1:contact_email xpath="${xpath}/email" title="your email address" required="true" size="40"/><span id="email_note">For confirming quote and transaction details</span>
		</form_v1:row>

		<form_v1:row label="Phone number">
			<%--This should be cleaned up to use Flexi_contact_number when LIFE is refactored--%>
			<field_v1:contact_telno xpath="${xpath}/contactNumber" required="true" title="phone number"  />
		</form_v1:row>

		<c:if test="${empty callCentre}">
			<%-- Mandatory agreement to privacy policy --%>
			<form_v1:privacy_optin vertical="${vertical}" />
		</c:if>

		<form_v1:row label="Postcode">
			<field_v1:post_code_and_state xpath="${vertical}/primary/postCode" title="${error_phrase_postcode}postcode" required="true" className="" />
		</form_v1:row>

		<%-- COMPETITION START --%>
		<c:if test="${competitionEnabled == true}">
			<c:set var="competitionId"><content:get key="competitionId"/></c:set>
			<form_v1:row label="" className="promo-row">
				<div class="promo-container">
					<div class="promo-image ${vertical}-${competitionId}"></div>
				</div>
			</form_v1:row>
		
			<form_v1:row label="" className="clear">
				<c:set var="competitionCheckboxText">
					<content:get key="competitionCheckboxText" />
				</c:set>
				<field_v1:checkbox
						xpath="${xpath}/competition/optin"
						value="Y"
						title="${competitionCheckboxText}"
						required="false"
						label="true"/>
				<field_v1:hidden xpath="${xpath}/competition/previous" />
			</form_v1:row>
		</c:if>
		<%-- COMPETITION END--%>

		<c:if test="${lif406SplitTest eq false}">
			<life_v1:contact_optin vertical="${vertical}" />
		</c:if>


            <field_v1:hidden xpath="${xpath}/optIn" />
            <field_v1:hidden xpath="${xpath}/call" />
            <field_v1:hidden xpath="${vertical}/splitTestingJourney" constantValue="${splitTestingJourney}" />

        </form_v1:fieldset>

    </div>

    <%-- CSS --%>
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

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#${name}_call").buttonset();
	});

	${name}_original_phone_number = $('#${contactNumber}').val();

	$("#${vertical}_privacyoptin").on("change", function(){
		$('#${optIn}').val($(this).is(":checked") ? "Y" : "N");
		$('#${name}_optIn').val($(this).is(":checked") ? 'Y' : 'N');
	});

	$("#${vertical}_privacyoptin").trigger("change");

	$('#${contactNumber}input').on('update keypress blur', function(){

		var tel = $(this).val();

		if(!tel.length || ${name}_original_phone_number != tel){
			$('#${name}_call').find('label[aria-pressed="true"]').each(function(key, value){
				$(this).attr("aria-pressed", "false");
				$(this).removeClass("ui-state-active");
				$('#' + $(this).attr("for")).removeAttr("checked");
			});
		};

		${name}_original_phone_number = tel;
	});

	<%-- Life split test makes phone mandatory so no
		 need to do it here if split test is active --%>
	<c:if test="${competitionEnabled eq true and lif406SplitTest eq false}">
		$('#${vertical}_contactDetails_competition_optin[type="checkbox"]').on('change', function(e){
			if(this.checked) {
				<%-- 
					Opt In -- Unset phone number as mandatory field 
				--%>
				$('#${vertical}_contactDetails_contactNumberinput').attr('required', 'required').addClass('state-force-validate');
			} else {
				<%-- 
					Opt Out -- Unset phone number as mandatory field
				--%>
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

	$('#${name}_email').change(function() {
		$(document).trigger(SaveQuote.setMarketingEvent, [$('#${name}_optIn').val() === "Y", $(this).val()]);
	});
</go:script>

