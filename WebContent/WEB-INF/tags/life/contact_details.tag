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

<c:choose>
	<%-- No results journey --%>
	<c:when test="${not empty param.jrny and param.jrny eq 'noresults'}">
		<c:set var="splitTestingJourney"><c:out value="${param.jrny}" /></c:set>
	</c:when>
	<%-- Standard journey --%>
	<c:otherwise>
		<c:set var="splitTestingJourney" value="original" />
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form:fieldset legend="Your Contact Details">

		<life:name xpath="${vertical}/primary" vertical="${vertical}" />
		
		<form:row label="Surname" className="clear">
			<field:input xpath="${vertical}/primary/lastname" title="${error_phrase}surname" required="true" size="13" />
		</form:row>
		
		<go:validate selector="${vertical}_primary_lastname" rule="personName" parm="true" />

		<form:row label="Your email address" className="clear email-row">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="true" size="40"/><span id="email_note">For confirming quote and transaction details</span>
		</form:row>

		<form:row label="Your phone number">
			<field:contact_telno xpath="${xpath}/contactNumber" required="false" title="phone number"  />
		</form:row>

		<c:if test="${empty callCentre}">
			<%-- Mandatory agreement to privacy policy --%>
			<form:privacy_optin vertical="${vertical}" />
		</c:if>

		<form:row label="Postcode">
			<field:post_code_and_state xpath="${vertical}/primary/postCode" title="${error_phrase_postcode}postcode" required="true" className="" />
		</form:row>

		<%-- COMPETITION START --%>
		<c:if test="${competitionEnabled == true}">
			<form:row label="" className="promo-row">
				<div class="promo-container">
					<div class="promo-image ${vertical}"></div>
				</div>
			</form:row>
		
			<form:row label="" className="clear">
				<c:set var="competitionCheckboxText"><content:get key="competitionCheckboxText" /></c:set>
				<field:hidden xpath="${xpath}/competition/optin" constantValue="N" />
				<field:checkbox xpath="${xpath}/competition/optin" value="Y" title="${competitionCheckboxText}" required="false" label="true"/>
				<field:hidden xpath="${xpath}/competition/previous" />
			</form:row>
		</c:if>
		<%-- COMPETITION END--%>
		
		<form:row label="" className="clear">
			<field:checkbox xpath="${xpath}/optIn" value="Y" title="I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" required="false" label="true"/>
		</form:row>
		
		<form:row label="" className="clear closer">
			<c:set var="privacyLink" value="<a href='javascript:void(0);' onclick='${vertical}_privacyoptinInfoDialog.open()'>privacy statement</a>" />
			
			<c:choose>
				<c:when test="${vertical eq 'life'}">
					<c:set var="label_text">
						I understand comparethemarket.com.au compares life insurance policies from a range of <a href="javascript:void(0);" onclick="participatingSuppliersDialog.open();">participating suppliers</a>. By entering my telephone number I agree that Lifebroker and/or Auto and General Services, Compare the Market&#39;s trusted life insurance partners may contact me to further assist with my life insurance needs. I confirm that I have read the ${privacyLink}.
					</c:set>
				</c:when>
				<c:when test="${vertical eq 'ip'}">
					<c:set var="label_text">
						I understand comparethemarket.com.au compares life insurance policies from a range of <a href="javascript:void(0);" onclick="participatingSuppliersDialog.open();">participating suppliers</a>. By entering my telephone number I agree that Lifebroker, Compare the Market&#39;s trusted life insurance and income protection partner may contact me to further assist with my life insurance and income protection needs. I confirm that I have read the ${privacyLink}.
					</c:set>
				</c:when>
			</c:choose>
			
			<field:checkbox
				xpath="${vertical}_privacyoptin"
				value="Y"
				title="${label_text}"
				errorMsg="Please confirm you have read the privacy statement"
				required="true"
				label="true"
			/>
		</form:row>

		<field:hidden xpath="${xpath}/call" />
		<field:hidden xpath="${vertical}/splitTestingJourney" constantValue="${splitTestingJourney}" />

	</form:fieldset>

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

	$('#${name}_optIn').change(function() {
		$(document).trigger(SaveQuote.setMarketingEvent, [$(this).attr('checked'), $('#${name}_email').val()]);
	});
	$('#${name}_email').change(function() {
		$(document).trigger(SaveQuote.setMarketingEvent, [$('#${name}_optIn').attr('checked'), $(this).val()]);
	});
</go:script>

