<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<ui:popup_window />

<go:script marker="onready">

	<life_v1:custom_contact_panel />

	slide_callbacks.register({
		mode:			'before',
		slide_id:		-1,
		callback:		function(){
			if(QuoteEngine._options.currentSlide > 0 && QuoteEngine._options.currentSlide < 3) {
				$('#reference_number').fadeOut('fast');
			} else {
				$('#reference_number').fadeIn('fast');
			}

			if(LifeQuote._vertical == "life") {
				var $contactPanel = $('.lifebroker-contact-panel');
				var primaryResult = Results.getPrimarySelectedProduct();
				if(QuoteEngine._options.currentSlide == 2 && typeof primaryResult.company !== "undefined" && LifeQuote.isOzicare(primaryResult.company)) {
					$contactPanel.find('.provider-phone-number').text(primaryResult.insurer_contact);
					$contactPanel.find('.call-provider-message span').text(primaryResult.companyName);
				} else {
					var $providerPhone = $contactPanel.find('.provider-phone-number');
					$providerPhone.text($providerPhone.data('original'));
					var $providerName = $contactPanel.find('.call-provider-message');
					$providerName.find('span').text($contactPanel.data('original'));
		}

				if(QuoteEngine._options.currentSlide == 3) {
					if(LifeQuote.isOzicare(primaryResult.company)) {
						$('#life-confirmation .column.left .inner.left .panel p:nth-child(2)').hide();
					} else {
						$('#life-confirmation .column.left .inner.left .panel p:nth-child(2)').show();
					}
				}

				if(QuoteEngine._options.currentSlide == 0 && LifeQuote._vertical == 'life') {
					$('#reference_number').hide();
				} else {
					$('#reference_number').show();
				}

				if(QuoteEngine._options.currentSlide == 2) {
					$('.what-next .phone-no-replace').text(primaryResult.insurer_contact);
				}

				if(QuoteEngine._options.currentSlide == 1) {
					$('#contact-panel').hide();
				} else {
					$('#contact-panel').show();
				}
			}
		}
	});

	QuoteEngine.nextSlide(function(currentSlide){
		switch(currentSlide){
			case 0:
				LifeQuote.fetchPrices(true);
				return true;
				break;
			default:
				return true;
		}
	});

	$('#reference_number').hide();

	Track.onQuoteEvent('Start', referenceNo.getTransactionID(false));
	Track.nextClicked(0, referenceNo.getTransactionID(false));

	referenceNo.overrideSave(function(){
		var defaults = {
			email: $("#" + LifeQuote._vertical + "_contactDetails_email").val(),
			optin: $("#" + LifeQuote._vertical + "_contactDetails_optIn").is(":checked") ? "Y" : "N"
		}
		SaveQuote.show( SaveQuote._SAVE, defaults, function( optin ) {
			if( optin == "Y" )
			{
				$("#" + LifeQuote._vertical + "_contactDetails_optIn").attr("checked", "true");
			}
			else
			{
				$("#" + LifeQuote._vertical + "_contactDetails_optIn").removeAttr("checked");
			}
		} );
	});

	$(document).on('click','a[data-savequote=true]',function(){

		SaveQuote.show();

	});

	(function(){
		var gaClientId = null;

		// Retrieve the _ga cookie and assign its value to gaClientId
		var cookieStr = document.cookie;
		if(cookieStr !== "") {
			var rawCookies = cookieStr.split(";");
			for(var i=0; i<rawCookies.length; i++){
				var cookie = $.trim(rawCookies[i]).split("=");
				if(cookie.length === 2) {
					if(cookie[0] === "_ga") {
						gaClientId = cookie[1];
						break;
					}
				}
			}
		}

		// Derive element name and if exists then assign value or create a new one
		if(!_.isEmpty(gaClientId)) {
			var customGAClientId = gaClientId;
			var temp = gaClientId.split('.');
			if(temp.length >= 2) {
				var partB = temp.pop();
				var partA = temp.pop();
				customGAClientId = partA + '.' + partB;
			}

			var elementName = LifeQuote._vertical + '_gaclientid';
			if($('#' + elementName).length) {
				$('#' + elementName).val(customGAClientId);
			} else {
				$('#mainform').prepend($('<input/>', {
					type: 'hidden',
					id: elementName,
					name: elementName,
					value: customGAClientId
				}));
			}
		}
	})();

	<%-- GLOBAL JS VARIABLE FOR GA TO DISINGUISH LOCAL USERS --%>
	<jsp:useBean id="ipChkSvc" class="com.ctm.web.core.services.IPCheckService" scope="page" />
	<c:set var="localIP">
		<c:choose>
			<c:when test="${ipChkSvc.isLocalIPAddress(pageContext.getRequest()) eq true}">${true}</c:when>
			<c:otherwise>${false}</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="isPreload">
		<c:choose>
			<c:when test="${not empty param.preload}">${true}</c:when>
			<c:otherwise>${false}</c:otherwise>
		</c:choose>
	</c:set>
	<c:set var="isGtmInternalUser">
		<c:choose>
			<c:when test="${not empty param.gtmInternaluser}">${true}</c:when>
			<c:otherwise>${false}</c:otherwise>
		</c:choose>
	</c:set>
	window.at = <c:choose><c:when test="${localIP eq true or isGtmInternalUser eq true or isPreload eq true}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
	<%-- END GLOBAL JS VARIABLE --%>

    </go:script>

    <form_v1:radio_button_group_validate />
