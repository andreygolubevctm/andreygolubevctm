<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>

<%-- VARIABLES --%>
<c:set var="testing_mode">false</c:set>
<c:set var="is_callcentre">
	<c:choose>
		<c:when test="${empty callCentre}"><c:out value="false" /></c:when>
		<c:otherwise><c:out value="true" /></c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>

<%-- JAVASCRIPT --%>

<go:script marker="js-head">
var OptinHandler = function() {

	var that = 				this,
		elements = 			{},
		valid_elements = 	true,
		<%-- Stores ONLY emails that are opted in - otherwise FALSE --%>
		primary_email = 	{
			qs :	false,
			app :	false
		},
		email_history = 	{
			qs :	[],
			app :	[]
		},
		<%-- Flag whether to output optin data when updated (on if console available) --%>
		testing_mode = ${testing_mode};

	var init = function(){

		<%-- All elements needed to maintain optin --%>
		elements = {
			qs	: {
				email	: {
					primary		: $('#health_contactDetails_email'),
					secondary	: $('#health_contactDetails_emailsecondary'),
					history		: $('#health_contactDetails_emailhistory'),
					optin		: $('#health_contactDetails_optInEmail')
				},
				phone	: {
					mobileinput	: $('#health_contactDetails_contactNumber_mobileinput'),
					mobile		: $('#health_contactDetails_contactNumber_mobile'),
					otherinput	: $('#health_contactDetails_contactNumber_otherinput'),
					other		: $('#health_contactDetails_contactNumber_other'),
					optin		: $('#health_contactDetails_call')
				}
			},

			app	: {
				email	: {
					primary		: $('#health_application_email'),
					secondary	: $('#health_application_emailsecondary'),
					history		: $('#health_application_emailhistory'),
					optin		: $('#health_application_optInEmail')
				},
				phone	: {
					mobileinput	: $('#health_application_mobileinput'),
					mobile		: $('#health_application_mobile'),
					otherinput	: $('#health_application_otherinput'),
					other		: $('#health_application_other'),
					optin		: $('#health_application_call')
				}
			},

			optin : $('#health_contactDetails_optin')
		};

		<%-- Test that no elements are missing or have been renamed --%>
		validateElements();

		if( valid_elements ) {

			<%-- Add listener to update optins when exiting first page of application --%>
			slide_callbacks.register({
				mode:		"before",
				direction:	"forward",
				slide_id:	4,
				callback: 	function() {
					that.update(true);
				}
			});

			<%-- Add listeners for application email and phone to toggle optin field visibility --%>
			elements.app.email.primary.change( that.toggleOptinFields );
			elements.app.phone.mobileinput.change( that.toggleOptinFields );
			elements.app.phone.otherinput.change( that.toggleOptinFields );

			<%-- Add listener to toggle optin visibility on 1st application slide --%>
			slide_callbacks.register({
				mode:		"before",
				direction:	"forward",
				slide_id:	3,
				callback: 	that.toggleOptinFields
			});

			<%-- Do an update at the start (really only for benefit of pre-load) --%>
			that.update();
		}
	};

	<%-- Public method to perform optin update --%>
	this.update = function( is_application ) {

		is_application = is_application || false;

		if( valid_elements ) {

			<%-- Different handler for the questionset and application sections
				asquestionset is auto optin if email/phone entered whereas the
				application state is a manual process with checkboxes --%>
			if( is_application === true ) {
				updateAppOptin();
			} else {
				updateQSOptin();
			}

			<%-- Echo out the optin data if in testing mode --%>
			if(testing_mode === true) {
				that.dump();
			}
		}
	};

	<%-- updateQSOptin - handle the optins at the questionset phase --%>
	var updateQSOptin = function() {

		<%-- Optin QuestionSet emails and phone if universal optin checked --%>
		if( elements.optin.is(':checked') ) {

			<%-- Collect email and phone values --%>
			var prim_email = elements.qs.email.primary.val();
			var ph_mobile = elements.qs.phone.mobile.val();
			var ph_other = elements.qs.phone.other.val();

			if( $.browser.msie ) { <%-- Cleanup IEs use of the placeholder as its value --%>
				ph_mobile = ph_mobile.indexOf('(00') === 0 ? '' : ph_mobile;
				ph_other = ph_other.indexOf('(00') === 0 ? '' : ph_other;
			}

			<%-- First, handle phone optin --%>
			if( ph_mobile != '' || ph_other != '' ) {

				<%-- Set phone optin to YES --%>
				elements.qs.phone.optin.val('Y');

				<%-- If no application phone provided then populate from questionset --%>
				if( elements.app.phone.mobile.val() == '' && ph_mobile != '' ) {
					elements.app.phone.mobileinput.val( elements.qs.phone.mobileinput.val() );
					elements.app.phone.mobile.val( elements.qs.phone.mobile.val() );
				}
				if( elements.app.phone.other.val() == '' && ph_other != '' ) {
					elements.app.phone.otherinput.val( elements.qs.phone.otherinput.val() );
					elements.app.phone.other.val( elements.qs.phone.other.val() );
				}
			} else {
				<%-- Otherwise unset the optin for call input --%>
				elements.qs.phone.optin.val('N');
			}

			<%-- Next, handle email optin --%>
			if( isValidEmailAddress(prim_email) ) {

				<%-- Set email optin to YES --%>
				elements.qs.email.optin.val('Y');

				<%-- Update email fields (primary, secondary and history) --%>
				if( prim_email != primary_email.qs ) {
					<%-- Set primary_email if unset (nothing more to do) --%>
					if( primary_email.qs === false ) {
						primary_email.qs = prim_email;
					} else {
						<%-- If secondary is unassigned then assign it the existing primary qs email --%>
						if( elements.qs.email.secondary.val() == '' ) {
							elements.qs.email.secondary.val( primary_email.qs );
						<%-- Otherwise push existing secondary to the history then assign it the primary qs email --%>
						} else {
							var sec_email = elements.qs.email.secondary.val();
							var pos = arrayIndex(email_history.qs, sec_email);
							if( pos === false ) {
								email_history.qs.push(sec_email);
							}
							elements.qs.email.secondary.val( primary_email.qs );
						}

						<%-- Assign new email to primary_email --%>
						primary_email.qs = prim_email;

						<%-- Remove new primary email from history (if exists) --%>
						var index = arrayIndex(email_history.qs, primary_email.qs);
						if( index !== false ) {
							email_history.qs.splice(index, 1);
						}

						<%-- Update history field with the current history  --%>
						var history = "";
						if( email_history.qs.length ) {
							history = email_history.qs.join(',');
						}
						elements.qs.email.history.val( history );
					}

					<%-- Let save quote form know of opted in email--%>
					$(document).trigger(SaveQuote.setMarketingEvent, [true, primary_email.qs]);

					<%-- If no application email exists then populate from questionset --%>
					if( primary_email.app === false ) {
						elements.app.email.primary.val(primary_email.qs);
						primary_email.app = primary_email.qs;
					}
				}
			}
		<%-- Otherwise optout --%>
		} else {
			primary_email.qs = false;
			elements.qs.email.optin.val('N');
			elements.qs.phone.optin.val('N');
		}
	};

	<%-- updateAppOptin - handle the optins at the application phase --%>
	var updateAppOptin = function() {

		<%-- Collect email and (care not for phone numbers) --%>
		var prim_email = elements.app.email.primary.val();
		var sec_email = elements.app.email.secondary.val();

		<%-- Next, handle email optin --%>
		if( isValidEmailAddress(prim_email) ) {

			var is_optin = elements.app.email.optin.is(':checked');

			<%-- Update email fields (primary, secondary and history) --%>
			if( prim_email != primary_email.app ) {

				<%-- Only proceed if email opted in --%>
				if( is_optin ) {

					<%-- Do this step is there's an existing opted in email --%>
					if( primary_email.app !== false ) {

						<%-- If secondary is unassigned then assign it the existing primary app email --%>
						if( elements.app.email.secondary.val() == '' ) {
							elements.app.email.secondary.val( primary_email.app );
						<%-- Otherwise push existing secondary to the history then assign it the primary app email --%>
						} else {
							var pos = arrayIndex(email_history.app, sec_email);
							if( pos === false ) {
								email_history.app.push(sec_email);
							}
							elements.app.email.secondary.val( primary_email.app );
						}
					}

					<%-- Assign new email to primary_email --%>
					primary_email.app = prim_email;

					<%-- Remove new primary email from history (if exists) --%>
					var index = arrayIndex(email_history.app, primary_email.app);
					if( index !== false ) {
						email_history.app.splice(index, 1);
					}

					<%-- Update history field with the current history  --%>
					var history = "";
					if( email_history.app.length ) {
						history = email_history.app.join(',');
					}
					elements.app.email.history.val( history );

				<%-- Otherwise remove email from secondary or history if exists --%>
				} else {
					if( sec_email == prim_email ) {
						<%-- Push existing email to secondary position (new primary is the entered email) --%>
						elements.app.email.secondary.val( primary_email.app );
					} else {
						var index = arrayIndex(email_history.app, prim_email);
						if( index !== false ) {
							email_history.app.splice(index, 1);
						}
					}

					primary_email.app = false; <%-- Remove as not opted in --%>
				}
			<%-- Otherwise simply remove the primary email record and history --%>
			} else if ( !is_optin ) {
				primary_email.app = false;
			} else {
				primary_email.app = prim_email;
			}
		<%-- Otherwise unset primary email and optout --%>
		} else {
			primary_email.app = false;
			elements.app.email.optin.prop('checked', false);
		}
	};

	<%-- toggleOptinFields - show/hide the email/phone optin fields in the application phase --%>
	this.toggleOptinFields = function() {

		<%-- Check marketing optin - show if no email in questionset or IS Simples --%>
		if( ${is_callcentre} === true || elements.qs.email.primary.val() == '' || elements.qs.email.primary.val() != elements.app.email.primary.val()) {
			$('#health_application_optInEmail-group').show();
		}

		var phoneCallback = function() {
			<%-- Check okToCall optin - show if no phone numbers in questionset and NOT Simples --%>
			var qs_ph_mobile = elements.qs.phone.mobile.val();
			var qs_ph_other = elements.qs.phone.other.val();
			var app_ph_mobile = elements.app.phone.mobile.val();
			var app_ph_other = elements.app.phone.other.val();

			if( $.browser.msie ) { <%-- Cleanup IEs use of the placeholder as its value --%>
				qs_ph_mobile = qs_ph_mobile.indexOf('(00') === 0 ? '' : qs_ph_mobile;
				qs_ph_other = qs_ph_other.indexOf('(00') === 0 ? '' : qs_ph_other;
				app_ph_mobile = app_ph_mobile.indexOf('(00') === 0 ? '' : app_ph_mobile;
				app_ph_other = app_ph_other.indexOf('(00') === 0 ? '' : app_ph_other;
			}
			if(
				${is_callcentre} === false && (
					(qs_ph_mobile == '' && qs_ph_other == '') ||
					(app_ph_mobile != '' && qs_ph_mobile != app_ph_mobile) ||
					(app_ph_other != '' && qs_ph_other != app_ph_other)
				) ) {
				$('#health_application_okToCall-group').show();
			} else {
				$('#health_application_okToCall-group').hide();
			}
		}

		<%-- Delay needed to account for time to handle the blur event to update the number field --%>
		setTimeout(phoneCallback, 200);
	};

	<%-- Confirms all expected optin related fields exist --%>
	var validateElements = function() {

		var sections = ['optin','qs','app'];
		var types = ['email','phone'];
		for(var i = 0; i < sections.length; i++) {
			if( elements.hasOwnProperty(sections[i]) ) {
				var section = elements[sections[i]];
				if( sections[i] == 'optin' ) {
					if( section.length == 0 ) {
						valid_elements = false;
					}
				} else if( valid_elements === true ) {
					for(var j = 0; j < types.length; j++) {
						if( section.hasOwnProperty(types[j]) ) {
							var fields = section[types[j]];
							for(var k in fields) {
								if( fields.hasOwnProperty(k) ) {
									if( fields[k].length == 0 ) {
										valid_elements = false;
									}
								}
							}
						}
					}
				}
			}
		}

		if( !valid_elements ) {
			FatalErrorDialog.exec({
				message:		"A field related to email/phone optins has been renamed or is missing.",
				page:			"optin_handler.tag",
				description:	"An expected Health xpath related to email/phone optins has been renamed or is missing.",
				data:			null
			});
		}
	};

	<%-- Public method to output the current optin data object --%>
	this.dump = function() {

		var data = {
			qs	: {
				email	: {
					primary		: $('#health_contactDetails_email').val(),
					secondary	: $('#health_contactDetails_emailsecondary').val(),
					history		: $('#health_contactDetails_emailhistory').val(),
					optin		: $('#health_contactDetails_optInEmail').val()
				},
				phone	: {
					mobile		: $('#health_contactDetails_contactNumber_mobile').val(),
					other		: $('#health_contactDetails_contactNumber_other').val(),
					optin		: $('#health_contactDetails_call').val()
				}
			},

			app	: {
				email	: {
					primary		: $('#health_application_email').val(),
					secondary	: $('#health_application_emailsecondary').val(),
					history		: $('#health_application_emailhistory').val(),
					optin		: $('#health_application_optInEmail').is(':checked')
				},
				phone	: {
					mobile		: $('#health_application_mobile').val(),
					other		: $('#health_application_other').val(),
					optin		: $('#health_application_call').is(':checked')
				}
			},

			optin : $('#health_contactDetails_optin').is(':checked'),
			primary_email : primary_email,
			email_history : email_history
		};

		if( !$.browser.msie ) {
			try{
				console.info(data);
			} catch(e) { /* IGNORE */ }
		}
	};

	<%-- Helper functions --%>

	var arrayIndex = function(arr, token) {
		if( typeof arr == "object" && arr.constructor == Array ) {
			for(var i = 0; i < arr.length; i++) {
				if( arr[i] == token ) {
					return i;
				}
			}
		}

		return false;
	};

	<%-- Initialise object when object is instantiated --%>
	init();
}

var optin_handler;
</go:script>

<go:script marker="onready">
optin_handler = new OptinHandler();
</go:script>