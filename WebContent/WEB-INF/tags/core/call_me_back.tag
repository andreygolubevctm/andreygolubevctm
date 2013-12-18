<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%--
This tag renders a button on the page which can trigger a form for
the user to request a callback from the Call Centre.
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="quoteType" required="true" rtexprvalue="true"	description="The vertical this quote is associated with" %>
<%@ attribute name="qsFirstNameField" required="true" rtexprvalue="true"	description="The ID of the name/firstname field in the questionset" %>
<%@ attribute name="qsLastNameField" required="false" rtexprvalue="true"	description="The ID of the lastname field in the questionset" %>
<%@ attribute name="qsOptinField" required="true" rtexprvalue="true"	description="The ID of the optin for calls field in the questionset" %>
<%@ attribute name="id" required="false" rtexprvalue="true"	description="ID to assign to parent element" %>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="Class name to assign to parent element" %>

<c:if test="${empty id}">
	<c:set var="id" value="callmebackregion" />
</c:if>

<%-- VARIABLES --%>
<c:set var="formHeight" value="245" />
<c:set var="prefix" value="${quoteType}_callmeback_" />
<c:set var="nameField" value="${prefix}name" />
<c:set var="phoneField" value="${prefix}phone" />
<c:set var="timeofDayField" value="${prefix}timeOfDay" />
<c:set var="timeField" value="${prefix}time" />
<c:set var="dateField" value="${prefix}date" />
<c:set var="optinField" value="${prefix}optin" />
<c:set var="nameFieldXpath" value="${fn:replace(nameField, '_','/')}" />
<c:set var="phoneFieldXpath" value="${fn:replace(phoneField, '_','/')}" />
<c:set var="timeofDayFieldXpath" value="${fn:replace(timeofDayField, '_','/')}" />
<c:set var="optinFieldXpath" value="${fn:replace(optinField, '_','/')}" />

<%-- HTML --%>
<div id="${id}" class="${className}">
	<div id="${id}_panel">
		<a id="${id}_close" href="javascript:void(0)">X</a>
		<div id="${id}_thanks"></div>
		<div id="${id}_error">Sadly our call back service is offline - Please try again later.</div>
		<span id="${id}_form">
			<p>Enter your details below and we&#39;ll get someone to call you.</p>
			<div class="row">
				<span class="label">Your Name:</span><field:input xpath="${nameFieldXpath}" title="name" required="false" />
			</div>
			<div class="row">
				<span class="label">Contact number:</span><field:contact_telno xpath="${phoneFieldXpath}" required="true" title="Phone Number" size="20" className="inlineValidation" />
				<div class="errorField">
			</div>
			</div>
			<div class="row">
				<span class="label">Best time to call:</span><field:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)" xpath="${timeofDayFieldXpath}" title="Best time to call" required="true" />
			</div>
			<field:hidden xpath="${timeField}" defaultValue="N" />
			<field:hidden xpath="${dateField}" defaultValue="N" />
			<field:hidden xpath="${optinFieldXpath}" defaultValue="N" />
			<p class="sub">Our Australian based call centre hours are<br/>Mon - Thu: 8:30am to 8pm &amp; Fri: 8:30am-6pm (AEST)</p>

			<a href="javascript:void(0)" id="${id}_submit" class="standardButton greenButton">Submit</a>
		</span>
	</div>
	<a id="${id}_openclose" href="javascript:void(0)" class="cancel" ><!-- empty --></a>
</div>
<div id='${id}_mask'><!-- empty --></div>
<%-- SCRIPT --%>
<go:script marker="js-head">

<%-- JS class which handles the functionality of the CallMeBack form --%>
var CallMeBack = function() {

	// Private members area
	var that			= this,
		elements		= {},
		submitted		= false,
		submitting		= false,
		callMeBackContactDetails = new ContactDetails(),
		THANK_YOU		= "Thank you, a member of our staff will call you in the ";

	this.callMeBackResult = 'callMeBackResult';
	this.callMeBackSubmitEvent = 'callMeBackSubmitEvent';

	this.hide = function() {
		$('#${id}').hide();
		return false;
	},
	<%-- Collects form references and sets up listeners required --%>
	this.init = function() {
		elements = {
			openclose	: $('#${id}_openclose'),
			submit	: $('#${id}_submit'),
			close	: $('#${id}_close'),
			panel	: $('#${id}_panel'),
			form	: $('#${id}_form'),
			thanks	: $('#${id}_thanks'),
			error	: $('#${id}_error'),
			name	: $('#${nameField}'),
			phone	: $('#${phoneField}'),
			phoneInput	: $('#${phoneField}input'),
			time		: $('#${timeofDayField}'),
			optin	: $('#${optinField}'),
			mask	: $('#${id}_mask'),
			errors		: $("#${id} .errorField"),
			qs		: {
				firstname	: $('#${qsFirstNameField}'),
<c:choose>
	<c:when test="${not empty qsLastNameField}">
				lastname	: $('#${qsLastNameField}'),
	</c:when>
	<c:otherwise>
				lastname	: false,
	</c:otherwise>
</c:choose>
				optin		: $('#${qsOptinField}')
			}
		};

		elements.submit.on('click', function(){
			if( !submitting && !elements.openclose.hasClass('animating') ) {
				if( elements.openclose.hasClass('open') ) {
					if( !submitted ) {
						that.submit();
					}
				}
					} else {
				// ignore as animating or submitting
			}
		});

		elements.openclose.on('click', function(){
			if( !submitting && !elements.openclose.hasClass('animating') ) {
				if( elements.openclose.hasClass('open') ) {
						elements.close.trigger('click');
				} else {
					togglePanel();
				}
			} else {
				// ignore as animating or submitting
			}
		});

		elements.mask.on('click', function(){
			togglePanel( true );
			clearForm();
		});

		elements.close.on('click', function(){
			togglePanel( true );
			clearForm();
		});

		callMeBackContactDetails.init(elements.phoneInput , elements.phone , true, true);

	};

	<%-- Writes entire quote data (which includes the CallMeBack fields). Is contingent
		on agg:write_quote_onstep tag being included (which it should be) --%>
	this.submit = function() {
		if( !submitted ) {
			if( validate() ) {
				submitting = true;
				elements.optin.val('Y');
				var dat = serialiseWithoutEmptyFields('#mainform') + "&quoteType=${quoteType}";
				$.ajax({
					url: "ajax/write/request_callback.jsp",
					data: dat,
					dataType: "json",
					type: "POST",
					async: true,
					timeout:60000,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(jsonResult) {
						submitted = true;
						updateQuestionSet();
						toggleForm();
						<%--TODO: add messaging framework
							meerkat.messaging.publish(callMeBack.callMeBackResult, true, getThankYouMessage());
							meerkat.messaging.unSubscribe(callMeBack.callMeBackSubmitEvent, callMeBack.submitFromOutside, window);
						--%>
						$(document).trigger(callMeBack.callMeBackResult, [true, getThankYouMessage()]);
						$(document).off(callMeBack.callMeBackSubmitEvent, callMeBack.submitFromOutside);
						$('#${timeField}').val(jsonResult.time);
						$('#${dateField}').val(jsonResult.date);
						submitting = false;
					},
					error: function(obj, txt, errorThrown){
						elements.form.hide();
						elements.thanks.hide();
						elements.error.show();
							<%--TODO: add messaging framework
								meerkat.messaging.publish(callMeBack.callMeBackResult, false, "Sadly our call back service is offline - Please try again later.");
							--%>
						$(document).trigger(callMeBack.callMeBackResult, [false, "Sadly our call back service is offline - Please try again later."]);
						submitting = false;
					}
				});
				} else {
				elements.optin.val('N');
			}
		} else {
			togglePanel( true );
		}
	};

	this.submitFromOutside = function(name,phone,time, optIn) {
		elements.name.val(name)
		elements.phone.val(phone);
		elements.phoneInput.val(phone);
		elements.time.val(time);
		this.submit();
	};

	this.setPhoneNumber= function(inputs) {
		callMeBackContactDetails.setPhoneNumber(inputs ,false);
	};

	<%-- Validates the form and returns a boolean --%>
	var validate = function() {
		$("#mainform").validate().resetNumberOfInvalids();
		var is_valid = true;

		if( elements.name.val() == '' ) {
			elements.name.addClass('error');
			is_valid = false;
		} else {
			elements.name.removeClass('error');
		}
		if(!elements.phoneInput.valid()) {
			is_valid = false;
		}

		if( elements.time.val() == '' ) {
			elements.time.addClass('error');
			is_valid = false;
		} else {
			elements.time.removeClass('error');
		}

		return is_valid;
	};

	<%-- Toggles the rendering of the callmeback panel --%>
	var togglePanel = function( force ) {

		if( !submitting ) {

			toggleForm();

			if( force === true || elements.openclose.hasClass('open') ) {
				elements.panel.addClass('animating');
				elements.mask.hide();
				elements.openclose.fadeIn();
				elements.panel.animate({height:'1px',opacity:'0'}, 400, function(){
					elements.panel.removeClass('animating');
					elements.openclose.removeClass('open');
					elements.panel.hide();
				});
			} else {
				elements.openclose.fadeOut();
				callMeBackContactDetails.updatePhoneInputs();
				elements.panel.addClass('animating');
				elements.mask.css({height:$(document).height()});
				elements.mask.show();
				elements.panel.show().animate({height:'${formHeight}px', opacity:'1'}, 400, function(){
					elements.panel.removeClass('animating');
					elements.openclose.addClass('open');
					if( !submitted ) {
						updateCallMeBackForm();
					}
				});
			}
		}
	};

	<%-- Shows/Hides form, thanks and error content as required --%>
	var toggleForm = function() {

		if( submitted ) {
			elements.thanks.empty()
			.append(getThankYouMessage())
			.append(
				$('<a/>',{
					id:		'${id}_close_button',
					href:	'javascript:void(0)',
					text:	'Close'
				})
				.addClass('standardButton greenButton')
				.on('click', function(){
					elements.close.trigger('click');
				})
			);
			elements.form.hide();
			elements.thanks.show();
		} else {
			elements.form.show();
			elements.thanks.hide();
			elements.error.hide();
		}
	};
	var getThankYouMessage = function() {
			var time = '';
			switch( elements.time.val() ) {
				case 'M':
					time = "morning";
					break;
				case 'A':
					time = 'afternoon';
					break;
				case 'E':
				default:
					time = 'evening (excludes WA)';
					break;
			}
		return THANK_YOU +  time
		}

	<%-- Updates the callmeback form with the questionset --%>
	var updateCallMeBackForm = function() {
		if( !submitted ) {
			var fname = $.trim(elements.qs.firstname.val());
<c:choose>
	<c:when test="${not empty qsLastNameField}">
			var lname = $.trim(elements.qs.lastname.val());
	</c:when>
	<c:otherwise>
			var lname = '';
	</c:otherwise>
</c:choose>
			elements.name.val( $.trim(fname + ' ' + lname) );
			elements.time.find('option:selected').prop("selected", false);
		}
	};

	<%-- Updates the questionset with the callmeback form --%>
	var updateQuestionSet = function() {
		if( submitted ) {
<c:choose>
	<c:when test="${not empty qsLastNameField}">
			var names = $.trim(elements.name.val()).split(" ");

			if( elements.qs.firstname.val() == '' && names.length == 1 ) {
				elements.qs.firstname.val( names[0] );
			} else if ( elements.qs.lastname.val() == '' && names.length > 1 ) {
				elements.qs.firstname.val( names[0] );
				elements.qs.lastname.val( names.slice(1).join(" ") );
			}
	</c:when>
	<c:otherwise>
			var name = $.trim(elements.name.val());

			if( $.trim(elements.qs.firstname.val()) == '' ) {
				elements.qs.firstname.val( name );
			}
	</c:otherwise>
</c:choose>

			var phone = elements.phone.val();
			}
	};

	<%-- Clears out the form including error classes --%>
	var clearForm = function() {
		if( !submitted ) {
			elements.name.val('');
			if(elements.phoneInput.valid()) {
				var phoneNumber = elements.phone.val();
				var phoneNumberInput = elements.phoneInput.val();
				var phoneType = "mobile";
				if(isLandLine(phoneNumber)) {
					phoneType = "landline";
				}
				callMeBackContactDetails.userHasInteracted = false;
				callMeBackContactDetails.setPhoneNumber({
					phoneNumberInput : elements.phoneInput.val(),
					phoneNumber : elements.phone.val(),
					phoneType : phoneType,
					origin :[]
				}, false)
			}

			if (!Modernizr.input['placeholder']) {
				elements.phoneInput.val(elements.phoneInput.attr("placeholder"));
			} else {
			elements.phoneInput.val('');
			}
			elements.phone.val('');
			elements.time.find('option:selected').prop("selected", false);
			elements.optin.val('N');
			elements.name.removeClass('error');
			elements.time.removeClass('error');
			elements.phoneInput.removeClass('error');
			elements.errors.empty();
		}

	};

	var getHighestZIndex = function() {
		var maxZ = Math.max.apply(null,$.map($('body > *'), function(e,n){
				var index = parseInt($(e).css('z-index'))||1 ;
				return isNaN(index) ? 0 : index;
			})
		);
	};
};

var callMeBack = new CallMeBack();
</go:script>
<go:script marker="onready">
callMeBack.init();
	<%--TODO: add messaging framework
		meerkat.messaging.subscribe(callMeBack.callMeBackSubmitEvent, function(name,phone,time, optIn) {
			callMeBack.submitFromOutside(name,phone,time, optIn);
			}, window);
	--%>
	$(document).on(callMeBack.callMeBackSubmitEvent, function(event, name,phone,time, optIn) {
		callMeBack.submitFromOutside(name, phone, time, optIn);
	});

	$(document).on("CONTACT_DETAILS", function(event, inputs) {
		if(jQuery.type(inputs.phoneNumber) === "string") {
			callMeBack.setPhoneNumber(inputs);
		}
	});
</go:script>

<%-- STYLE --%>
<go:style marker="css-head">
#${id}{
	position:				relative !important;
	z-index:				26000 !important;
}

#${id}_submit {
	display:				block;
	margin:					3px auto 0 auto;
	padding:				8px 15px;
	width:					110px;
}

#${id}_openclose {
	display:				block;
	position: 				fixed;
	width:					179px;
	height:					48px;
	right: 					50%;
	bottom: 				0px;
	margin-right:			-429px;
	z-index: 				25002;
	background:				transparent url(common/images/request_callback/button.png) top left no-repeat;
}

#${id}_openclose:hover {
	background-position:	bottom left;
}

#${id}_mask {
	position: 				absolute;
	left: 					0;
	right: 					0;
	top: 					0;
	bottom: 				0;
	z-index: 				1000;
	background:				#000000;
	zoom: 					1;
	filter: 				alpha(opacity=20);
	opacity: 				0.2;
	visibility: 			visible;
	display:				none;
}

#${id}_panel {
	position: 				fixed;
	width:					300px;
	height:					${formHeight}px;
	right: 					50%;
	bottom: 				0px;
	margin-right:			-490px;
	z-index: 				25001;
	background-color:		#eff0f2;
	display:				none;
	border:					2px solid #FF6600;
	-webkit-border-radius:	8px;
	-moz-border-radius: 	8px;
	border-radius: 			8px;
	-webkit-box-shadow: 	0px 0px 5px rgba(0,0,0,0.4);
	-moz-box-shadow: 		0px 0px 5px rgba(0,0,0,0.4);
	box-shadow: 			0px 0px 5px rgba(0,0,0,0.4);
}

#${id}_panel input,
#${id}_panel select {
	border:					1px solid #cccccc !important;
	background:				#FFF;
	padding:				3px 5px;
}

#${id}_panel input {
	padding:				3px 5px;
}

#${id}_panel option {
	padding:				3px 5px;
	background:				#FFF;
}

#${id}_panel input.error,
#${id}_panel select.error {
	border-color:			#ff0000 !important;
}

#${id}_panel input,
#${id}_panel select,
#${id}_panel option {
	color:					#666666;
}

#${id}_panel .row,
#${id}_panel p{
	padding:				5px 10px;
}

#${id}_panel p{
	padding:				10px 20px 5px 15px;
}

#${id}_panel p.sub {
	font-size:				90%;
	text-align:				center;
	padding:				10px 20px;
}

#${id}_panel .row span{
	display:				inline-block;
	width:					100px;
	text-align:				right;
	padding-right:			5px;
}

#${id}_thanks,
#${id}_error {
	display:				none;
	position:				absolute;
	width:					250px;
	height:					40px;
	right: 					50%;
	top: 					50%;
	margin:					-40px -125px 0 0;
	z-index: 				25005;
	background:				#eff0f2;
	color:					#4A4F51;
	font-weight:			bold;
	font-size:				120%;
	line-height:			130%;
	text-align:				center;
}

#${id}_error {
	color:					#FF0000;
}

#${id}_close{
	display:				block;
	position:				absolute;
	width:					10px;
	height:					10px;
	top:					5px;
	right:					5px;
	background:				#eff0f2;
	color:					#FF6600;
	font-weight:			900;
	font-size:				120%;
	text-decoration:		none;
}

#${id}_close:hover{
	text-decoration:		underline;
}

#page {
	overflow:				visible;
}

#health_callmeback_name,
#health_callmeback_timeOfDay {
	margin-left:			3px;
}

#${id} .errorField {
	display:				none !important;
}

#${id}_close_button {
	display: 				block;
	width: 					110px;
	margin: 				10px auto
}

</go:style>