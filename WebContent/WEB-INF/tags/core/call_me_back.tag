<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
<%@ attribute name="qsPhoneNoField" required="true" rtexprvalue="true"	description="The ID of the phone number field in the questionset" %>
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
<c:set var="timeField" value="${prefix}time" />
<c:set var="optinField" value="${prefix}optin" />
<c:set var="nameFieldXpath" value="${fn:replace(nameField, '_','/')}" />
<c:set var="phoneFieldXpath" value="${fn:replace(phoneField, '_','/')}" />
<c:set var="timeFieldXpath" value="${fn:replace(timeField, '_','/')}" />
<c:set var="optinFieldXpath" value="${fn:replace(optinField, '_','/')}" />

<%-- HTML --%>
<div id="${id}" class="${className}">
	<div id="${id}_panel">
		<a id="${id}_close" href="javascript:void(0)">X</a>
		<div id="${id}_thanks">Thank you, a member of our staff will call you in the <span></span>.</div>
		<div id="${id}_error">Sadly our call back service is offline - Please try again later.</div>
		<span id="${id}_form">
			<p>Enter your details below and we&#39;ll get someone to call you.</p>
			<div class="row">
				<span class="label">Your Name:</span><field:input xpath="${nameFieldXpath}" title="name" required="false" />
			</div>
			<div class="row">
				<span class="label">Contact number:</span><field:contact_telno xpath="${phoneFieldXpath}" required="false" title="Phone Number" />
			</div>
			<div class="row">
				<span class="label">Best time to call:</span><field:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)" xpath="${timeFieldXpath}" title="Best time to call" required="false" />
			</div>
			<field:hidden xpath="${optinFieldXpath}" defaultValue="N" />
			<p class="sub">Our Australian based call centre hours are<br/>Mon - Fri: 8am to 8pm &amp; Sat: 10am-4pm (AEST)</p>
		</span>
	</div>
	<a id="${id}_submit" href="javascript:void(0)"><!-- empty --></a>
</div>

<%-- SCRIPT --%>
<go:script marker="js-head">

<%-- JS class which handles the functionality of the CallMeBack form --%>
var CallMeBack = function() {

	// Private members area
	var that			= this,
		elements		= {},
		submitted		= false,
		submitting		= false;

	<%-- Collects form references and sets up listeners required --%>
	this.init = function() {

		$('body').append("<div id='${id}_mask'><!-- empty --></div>");

		elements = {
			submit	: $('#${id}_submit'),
			close	: $('#${id}_close'),
			panel	: $('#${id}_panel'),
			form	: $('#${id}_form'),
			thanks	: $('#${id}_thanks'),
			error	: $('#${id}_error'),
			name	: $('#${nameField}'),
			phone	: $('#${phoneField}'),
			time	: $('#${timeField}'),
			optin	: $('#${optinField}'),
			mask	: $('#${id}_mask'),
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
				phone		: $('#${qsPhoneNoField}'),
				optin		: $('#${qsOptinField}')
			}
		};

		elements.submit.on('click', function(){
			if( !submitting && !elements.submit.hasClass('animating') ) {
				if( elements.submit.hasClass('open') ) {
					if( !submitted ) {
						that.submit();
					} else {
						elements.close.trigger('click');
					}
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
	};

	<%-- Writes entire quote data (which includes the CallMeBack fields). Is contingent
		on agg:write_quote_onstep tag being included (which it should be) --%>
	this.submit = function() {
		if( !submitted ) {
			if( validate() ) {
				elements.optin.val('Y');

				if( typeof writeQuoteOnStep == 'object' && writeQuoteOnStep instanceof WriteQuoteOnStep ) {
					submitting = true;
					if( writeQuoteOnStep.write({async:false}) ) {
						submitted = true;
						updateQuestionSet();
						toggleForm();
					} else {
						elements.form.hide();
						elements.thanks.hide();
						elements.error.show();
					}
					submitting = false;
				} else {
					FatalErrorDialog.exec({
						message:		"WriteQuoteOnStep object does not exist so can't submit Call Me Back request.",
						page:			"core::call_me_back.tag",
						description:	"Tag core:call_me_back is contingent on agg:write_quote_onstep being available to submit Call Me Back requests.",
						data:			{}
					});
				}
			} else {
				elements.optin.val('N');
			}
		} else {
			togglePanel( true );
		}
	};

	<%-- Validates the form and returns a boolean --%>
	var validate = function() {
		var is_valid = true;

		if( elements.name.val() == '' ) {
			elements.name.addClass('error');
			is_valid = false;
		} else {
			elements.name.removeClass('error');
		}

		if( elements.phone.val() == '' ) {
			elements.phone.addClass('error');
			is_valid = false;
		} else {
			elements.phone.removeClass('error');
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

			if( force === true || elements.submit.hasClass('open') ) {
				elements.panel.addClass('animating');
				elements.mask.fadeOut();
				elements.panel.animate({height:'1px',opacity:'0'}, 400, function(){
					elements.panel.removeClass('animating');
					elements.submit.removeClass('open');
					elements.panel.hide();
				});
			} else {
				elements.panel.addClass('animating');
				elements.mask.css({height:$(document).height()});
				elements.mask.fadeIn();
				elements.panel.show().animate({height:'${formHeight}px', opacity:'1'}, 400, function(){
					elements.panel.removeClass('animating');
					elements.submit.addClass('open');
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
			elements.thanks.find('span').first().empty().append( time )
			elements.form.hide();
			elements.thanks.show();
		} else {
			elements.form.show();
			elements.thanks.hide();
			elements.error.hide();
		}
	};

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
			elements.phone.val( $.trim(elements.qs.phone.val()) ).trigger('blur');
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

			if( elements.qs.phone.val() == '' ) {
				elements.qs.phone.val( phone ).trigger('blur');
			}
		}
	};

	<%-- Clears out the form including error classes --%>
	var clearForm = function() {
		if( !submitted ) {
			elements.name.val('');
			elements.phone.val('');
			elements.time.find('option:selected').prop("selected", false);
			elements.optin.val('N');
			elements.name.removeClass('error');
			elements.phone.removeClass('error');
			elements.time.removeClass('error');
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
</go:script>

<%-- STYLE --%>
<go:style marker="css-head">
#${id}_submit {
	display:				block;
	position: 				fixed;
	width:					179px;
	height:					48px;
	right: 					50%;
	bottom: 				0px;
	margin-right:			-359px;
	z-index: 				25002;
	background:				transparent url(common/images/request_callback/button.png) top left no-repeat;
}

#${id}_submit:hover {
	background-position:	bottom left;
}

#${id}_mask {
	position: 				absolute;
	left: 					0;
	right: 					0;
	top: 					0;
	bottom: 				0;
	z-index: 				25000;
	background-color:		rgba(0,0,0,0.2);
	<%--opacity: 				0;
	filter: 				alpha(opacity=100);
	-ms-filter:				"progid:DXImageTransform.Microsoft.Alpha(Opacity=100)";--%>
	visibility: 			visible;
	display:				none;
}

#${id}_panel {
	position: 				fixed;
	width:					300px;
	height:					${formHeight}px;
	right: 					50%;
	bottom: 				0px;
	margin-right:			-415px;
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
</go:style>