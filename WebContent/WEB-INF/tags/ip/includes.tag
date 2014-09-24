<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="ip" />

<%-- Save Quote Popup --%>
<quote:save_quote quoteType="${vertical}" mainJS="IPQuote" />

<%-- Dialog for errors during product comparisons --%>
<core:popup id="compare-error" title="Comare ERROR">
	<p id="compare-error-text">XXXXXXX</p>
	<div class="popup-buttons">
		<a href="javascript:void(0);" class="bigbtn close-error"><span>Ok</span></a>
	</div>
</core:popup>

<%-- Dialog for confirming telephone number before submission --%>
<life:popup_callbackconfirm />

<go:script marker="js-head">
	LifeQuote._vertical = 'ip';

	var QuestionSetUpdater = {
			close : function() {
				LBCalculatorDialog.close();
			}
	};
</go:script>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />

<life:includes_js_onready />
	
<go:script marker="onready">
	
	<c:if test="${isNewQuote eq false and not empty callCentre}">
		Track.contactCentreUser( '${data.ip.application.productId}', '${authenticatedData.login.user.uid}' );
			</c:if>

	$("#compare-error .close-error").click(function(){
		Popup.hide("#compare-error");
	});

	<%-- 
		Lifebroker lead gen:
		- Submit a new lead on blur if mandatory fields have been provided
		- Add a token so that subsequent requests know a lead was sent originally
		- Limit this similarly to Lifes lead gen
	--%>
	var IPLeadGen = {
		timeout: null,
		timeoutLength: 4000,
		$requiredInputs: $('#ip_primary_firstName, #ip_primary_lastname, #ip_contactDetails_email, #ip_contactDetails_contactNumberinput, #ip_primary_postCode, #ip_privacyoptin'),
		send: function() {
			var valid;

			<%-- Only do this on the first slide --%>
			if(QuoteEngine.getCurrentSlide() == 0) {
				valid = true;

				IPLeadGen.$requiredInputs.each(function() {
					var $this = $(this),
						id = $this.attr('id'),
						val = $this.val();

					if(id !== 'ip_contactDetails_contactNumberinput') {
						var validField = false;

						switch(id) {
							case 'ip_primary_firstName':
							case 'ip_primary_lastname':
							case 'ip_contactDetails_email':
								validField = (val !== '');
								break;
							case 'ip_primary_postCode':
								validField = /^[0-9]{4}/g.test(val);
								break;
							case 'ip_privacyoptin':
								validField = $('#' + id).is(':checked');
								break;
						}

						if(!validField)
							valid = false;
					}
				});
			} else {
				valid = false;
			}

			if(valid)
				LifeQuote.sendContactLead();
		}
	};

	IPLeadGen.$requiredInputs.on('click change keyup', function() {
		if(IPLeadGen.timeout)
			clearTimeout(IPLeadGen.timeout);

		if(!LifeQuote._contactLeadSent)
			IPLeadGen.timeout = setTimeout(IPLeadGen.send, IPLeadGen.timeoutLength);
	});

</go:script>

<go:style marker="css-head">
.contact_panel_small {
	font-size: 10px;
}
</go:style>