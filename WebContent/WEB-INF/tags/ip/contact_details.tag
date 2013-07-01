<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="IP Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="data xpath" %>
<%@ attribute name="required" 	required="false"	 rtexprvalue="true"	 description="whether its required" %>

<%-- VARIABLES --%>
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />
<c:set var="contactNumber"	value="${go:nameFromXpath(xpath)}_contactNumber" />
<c:set var="optIn"	value="${go:nameFromXpath(xpath)}_call" />

<%-- HTML --%>
<div id="${name}-selection" class="ip_contactDetails">

	<form:fieldset legend="Your Contact Details">

		<form:row label="Your email address" className="clear">
			<field:contact_email xpath="${xpath}/email" title="your email address" required="true" size="40"/><span id="email_note">For confirming quote and transaction details</span>
		</form:row>
		<form:row label="" className="clear closer">
			<field:checkbox xpath="${xpath}/optIn" value="Y" title="&nbsp;&nbsp;&nbsp;I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" required="false" label="true"/>
		</form:row>

		<form:row label="Your phone number">
			<field:contact_telno xpath="${xpath}/contactNumber" required="false" title="your phone number"  />

		</form:row>

		<c:if test="${empty callCentre}">
			<div class="ip_contactDetails_call">I understand comparethemarket.com.au compares income protection policies from a range of <a href="http://www.comparethemarket.com.au/income-protection/#tab_nav_1819_0" target="_blank">participating suppliers</a>. By entering my telephone number I agree that Lifebroker, Compare the Market&#39;s trusted life partner, may contact me to further assist with my income protection needs</div>
		</c:if>

		<field:hidden xpath="${xpath}/call" />

	</form:fieldset>



</div>

<%-- CSS --%>
<go:style marker="css-head">
	#ip_contactDetails .fieldrow_legend {
		float:		right;
		width:		125px;
		margin: 	4px 0px 0px 3px;
		font-size:	95%;
	}
	#${name}_call {
			float:left;
		}
	.ip_contactDetails_call {
			width: 400px;
			margin-left: 207px;
	}
	.ip_contact_agree {
			margin-top: 20px;
	}

	#ip_contactDetails_email {
		float: left;
	}
	#${name}-selection .clear { clear:both; }
	.ip-contact-details-call-group { min-height:0; }
	.ip-contact-details-call-group .fieldrow_value {padding-top:5px !important;}
	#email_note {
		width: 130px;
		float: right;
		font-size: 10px;
		color: #747170;
		padding-left: 10px;
		margin-top: 5px;
	}
	
	#${name}-selection .closer .fieldrow_value {
		margin-top: -7px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
	$(function() {
		$("#${name}_call").buttonset();
	});

	$("#${name}_optIn").parent().css({marginTop:'-7px', marginRight:'-5px'});

	${name}_original_phone_number = $('#${contactNumber}').val();

	$('#${optIn}').val( $('#${contactNumber}').val().length ? 'Y' : 'N');

	$('#${contactNumber}').on('update keypress blur', function(){

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

