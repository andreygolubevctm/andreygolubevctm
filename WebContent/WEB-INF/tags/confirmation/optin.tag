<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="vertical"		required="true"		rtexprvalue="true"	description="The label for the vertical" %>
<%@ attribute name="email" 			required="false"	rtexprvalue="true"	description="The email address to offer as optin" %>

<%-- VARIABLES --%>
<c:set var="xpath"	value="confirmation/optin" />
<c:set var="name"  value="${go:nameFromXpath(xpath)}" />

<%-- CHECK EMAIL ADDRESS --%>
<c:set var="show_form">${true}</c:set>


<c:if test="${not empty email}">

	<go:setData dataVar="data" value="${email}" xpath="${xpath}/email" />

	<security:authentication
		emailAddress="${email}"
		justChecking="true"
		vertical="${vertical}" />

		<%-- Suppress form is client already opted-in --%>
		<c:if test="${userData.loginExists eq 'true' and userData.optInMarketing eq 'true'}">
			<c:set var="show_form">${false}</c:set>
		</c:if>
</c:if>
<c:if test="${show_form eq true}">

	<%-- HTML --%>

	<div id="${name}" class="${name}">

		<form:fieldset legend="News and Offer Emails">

			<form:row label="Your email address" className="clear email-row">
				<field:contact_email xpath="${xpath}/email" title="your email address" required="false"  size="40"/>
			</form:row>

			<form:row label="Ok to email" className="email-optin-row clear closer">
				<field:checkbox xpath="${xpath}/optIn" value="Y" title="I agree to receive news &amp; offer emails from <strong>Compare</strong>the<strong>market</strong>.com.au" required="false" label="true"/>
			</form:row>

			<form:row label="" className="clear optin-button-row">
				<div
					class="col-sm-offset-4 col-lg-offset-3 col-xs-12 col-sm-6 col-md-3">
					<a id="confirmation_optin_button"
						class="btn btn-next btn-block nav-next-btn show-loading "
						href="javascript:;">Subscribe <span
						class="icon icon-arrow-right"></span></a>
				</div>
			</form:row>

			<form:row label="" className="clear optin-message-row">
				<p><!-- empty --></p>
			</form:row>

			<field:hidden xpath="${xpath}/details" defaultValue="${enc_details}" />

		</form:fieldset>

	</div>

	<%-- JAVASCRIPT --%>
	<go:script marker="js-head">

	var ConfirmationOptin = function() {

		var that = 			this,
			elements =		{},
			validation =	null,
			processing	=	false;

		var init = function() {

			validation = $('#mainform').validate();

			elements = {
				email:		$('#confirmation_optin_email'),
				optin:		$('#confirmation_optin_optIn'),
				details:	$('#confirmation_optin_details'),
				button:		$('#confirmation_optin_button'),
				buttonrow:	$('.optin-button-row:first'),
				messagerow:	$('.optin-message-row:first'),
				message:	$('.optin-message-row:first p:first')
			};

			elements.button.on('click', optin);
			elements.email.on('change', toggleButton);
			elements.optin.on('change', toggleButton);

			elements.optin.prop('checked', false);
			toggleButton();
		};

		var optin = function() {

			if (processing){
				return;
			}

			if( isValid() ) {
				processing = true;

				var data = {
					email:		elements.email.val(),
					optin:		elements.optin.is(':checked'),
					firstname:	"",
					lastname:	"",
					details:	elements.details.val()
				};

				$.ajax({
					url: "ajax/write/confirmation_email_optin.jsp",
					data: data,
					type: "POST",
					async: true,
					dataType: "json",
					timeout:60000,
					cache: false,
					beforeSend : function(xhr,setting) {
						var url = setting.url;
						var label = "uncache",
						url = url.replace("?_=","?" + label + "=");
						url = url.replace("&_=","&" + label + "=");
						setting.url = url;
					},
					success: function(response){
						processing = false;
						if( response.success == true ) {
							reset();
						} else {
							elements.buttonrow.slideUp('fast');
						}
						elements.message.addClass(response.success ? 'success' : 'failure').empty().append( response.message );
						elements.messagerow.slideDown('fast');
						return false;
					},
					error: function(obj,txt){
						processing = false;

						FatalErrorDialog.register({
							message:		"An error occurred when attempting optin client for marketing: " + txt,
							page:			"confirmation:ConfirmationOptin:optin()",
							description:	"Confirmation Page - an error occurred attempting client for marketing: " + txt,
							data:			data
						});
					}
				});
			} else {
				toggleButton();
			}
		};

		var toggleButton = function() {

			if( isValid() ) {
				elements.messagerow.slideUp('fast', function(){
					elements.buttonrow.slideDown('slow');
				});
			} else {
				elements.buttonrow.slideUp('fast');
			}
		};

		var reset = function() {
			elements.email.val('');
			elements.email.parent().removeClass('state-success');
			elements.optin.prop('checked', false);
			elements.messagerow.hide();
			elements.message.removeClass().empty();
			toggleButton();
		};

		var isValid = function() {
			return elements.optin.is(':checked') && elements.email.val() != '' && validation.valid();
		};

		init();
	}

	</go:script>

	<go:script marker="onready">
	(function(){
		new ConfirmationOptin();
	}())
	</go:script>

</c:if>
