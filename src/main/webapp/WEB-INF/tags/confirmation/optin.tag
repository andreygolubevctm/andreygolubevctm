<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Life Contact Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="email" 			required="false"	rtexprvalue="true"	description="The email address to offer as optin" %>

<%-- Encrypt details to avoid user tampering at the frontend --%>
<c:set var="secret_key" value="Dx-DgYrR2lJlzW1pNZPohA" />
<c:set var="enc_details">
	<go:AESEncryptDecrypt action="encrypt" key="${secret_key}"
		content="brand=${pageSettings.getBrandCode()},vertical=${pageSettings.getVerticalCode()},source=CONFIRMATION" />
</c:set>

<%-- Based off whether the provided email has already opted in --%>
<c:set var="show_form">${true}</c:set>
<c:if test="${not empty email}">
	<security:authentication emailAddress="${email}" justChecking="true" vertical="${pageSettings.getVerticalCode()}" />
	<c:if test="${userData.optInMarketing eq 'true'}">
			<c:set var="show_form">${false}</c:set>
		</c:if>
</c:if>

<c:if test="${show_form eq true}">

	<%-- HTML --%>
	<div id="confirmation" class="confirmation">

		<form_new:fieldset legend="News and Offer Emails">

			<form_new:row label="Your email address" className="clear email-row">
				<field_new:email xpath="confirmationOptIn/emailAddress" title="your email address"
					required="false" size="40" />
			</form_new:row>

			<form_new:row label="" className="email-optin-row clear closer">
				<field_new:checkbox xpath="confirmation/optIn" value="Y"
					title="Stay up to date with news and offers direct to your inbox."
					required="false" label="true" />
			</form_new:row>

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
				<p>
					<!-- empty -->
				</p>
			</form:row>
			<c:set var="confirmationId"><c:out value="${param.ConfirmationID}" escapeXml="true" /></c:set>
			<field:hidden xpath="confirmation/details" defaultValue="${enc_details}" />
			<field:hidden xpath="data/current/transactionId" defaultValue="${data.current.transactionId}" />
			<field:hidden xpath="confirmation/confirmationId" defaultValue="${confirmationId}" />
		</form_new:fieldset>
	</div>

	<%-- JAVASCRIPT --%>
	<go:script marker="js-head">

	var ConfirmationOptin = function() {

		var that = 			this,
			elements =		{},
			validation =	null,
			processing	=	false;

		var init = function() {
			validation = $('#confirmationForm').validate();
			elements = {
				email:		$('#confirmationOptIn_emailAddress'),
				optin:		$('#confirmation_optIn'),
				confirmationId:$('#confirmation_confirmationId'),
				transactionId: $('#data_current_transactionId'),
				details:	$('#confirmation_details'),
				button:		$('#confirmation_optin_button'),
				buttonrow:	$('.optin-button-row:first'),
				messagerow:	$('.optin-message-row:first'),
				fieldrows: 	$('.email-row, .email-optin-row'),
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
					confirmationId:	elements.confirmationId.val(),
					transactionId:	elements.transactionId.val(),
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
						elements.fieldrows.slideUp('fast', function() { $(this).remove() });
						return false;
					},
					error: function(obj,txt){
						processing = false;
						elements.message.removeClass('success').addClass('failure').empty().append( 'Sorry, we\'re unable to register you for news and offer emails at this time. Please try again later.' );
						elements.messagerow.slideDown('fast');
						elements.buttonrow.slideUp('fast');
						meerkat.modules.errorHandling.error({
							errorLevel: "silent",
							page: '/ctm/confirmation.jsp confirmation:optin',
							data: data,
							description: "Confirmation Page - an error occurred attempting to optin client for marketing: " + txt
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
