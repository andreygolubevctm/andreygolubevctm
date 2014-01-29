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
<c:set var="life_link">
	<c:choose>
		<c:when test="${fn:startsWith(name, 'ip_')}">income-protection</c:when>
		<c:otherwise>life-insurance</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="${name}-selection" class="${name}">

	<form:fieldset legend="Your Contact Details">

		<form:row label="Your email address" className="clear email-row">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="true" size="40"/><span id="email_note">For confirming quote and transaction details</span>
		</form:row>
		<form:row label="" className="email-optin-row clear closer">
			<field:checkbox xpath="${xpath}/optIn" value="Y" title="I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" required="false" label="true"/>
		</form:row>

		<form:row label="Your phone number">
			<field:contact_telno xpath="${xpath}/contactNumber" required="false" title="your phone number"  />

		</form:row>

		<c:if test="${empty callCentre}">
			<div class="${name}_call">I understand comparethemarket.com.au compares life insurance policies from a range of <a href="http://www.comparethemarket.com.au/${life_link}" target="_blank">participating suppliers</a>. By entering my telephone number I agree that Lifebroker, Compare the Market&#39;s trusted life partner, may contact me to further assist with my life insurance needs</div>
		</c:if>

		<field:hidden xpath="${xpath}/call" />

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

		$('#${optIn}').val( tel.length ? 'Y' : 'N');

		if(!tel.length || ${name}_original_phone_number != tel){
			$('#${name}_call').find('label[aria-pressed="true"]').each(function(key, value){
				$(this).attr("aria-pressed", "false");
				$(this).removeClass("ui-state-active");
				$('#' + $(this).attr("for")).removeAttr("checked");
			});
		};

		${name}_original_phone_number = tel;
	});

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

