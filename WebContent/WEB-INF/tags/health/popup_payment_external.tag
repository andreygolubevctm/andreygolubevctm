<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="External payment: Credit Card popup"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />


<%-- HTML --%>
<div id="${name}-content">
	<div class="${name}-launchers">
		<div class="${name}-credit">
			<form:fieldset legend="Your credit card details" className="no-background-color">
				<p>We now need to register your credit card through Westpac in order to process your payment. 
				Please be assured that your personal and financial information is treated as highly confidential and stored in accordance with data protection regulations.</p>
				<p><a href="javascript:paymentGateway.launch();" class="bigbtn"><span>Register your credit card details</span></a></p>
				<core:clear />
			</form:fieldset>
		</div>
		<div class="${name}-bank">
			<form:fieldset legend="Your bank account details" className="no-background-color">
				<p>We now need to register your bank account through Westpac in order to process your payment. 
				Please be assured that your personal and financial information is treated as highly confidential and stored in accordance with data protection regulations.</p>
				<p><a href="javascript:paymentGateway.launch();" class="bigbtn"><span>Register your bank account details</span></a></p>
				<core:clear />
			</form:fieldset>
		</div>
	</div>
	
	<div class="${name}-fails">
		<div class="${name}-credit">
			<form:fieldset legend="Your credit card details" className="no-background-color">
				<p>Oops! We were unable to register your credit card details. Please try again or call us.</p>
				<p>
					<a href="javascript:paymentGateway.launch();" class="bigbtn"><span>Register your credit card details</span></a>
					<div class="callus">or call us <strong>1800 77 77 12</strong></div>
				</p>
				<core:clear />
			</form:fieldset>
		</div>
		<div class="${name}-bank">
			<form:fieldset legend="Your bank account details" className="no-background-color">
				<p>Oops! We were unable to register your bank account details. Please try again or call us.</p>
				<p>
					<a href="javascript:paymentGateway.launch();" class="bigbtn"><span>Register your bank account details</span></a>
					<div class="callus">or call us <strong>1800 77 77 12</strong></div>
				</p>
				<core:clear />
			</form:fieldset>
		</div>
	</div>
	
	<div class="${name}-success">
		<div class="${name}-credit">
			<form:fieldset legend="Your credit card details" className="no-background-color">
				<p>Thank you for registering your credit card details with Westpac.</p>
			</form:fieldset>
		</div>
		<div class="${name}-bank">
			<form:fieldset legend="Your bank account details" className="no-background-color">
				<p>Thank you for registering your bank account details with Westpac.</p>
			</form:fieldset>
		</div>
	</div>

	<input type="text" id="${name}-registered" name="${name}-registered" value="" disabled="disabled" />
	
	<div id="${name}-dialog" class="${name}-dialog"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#${name}-registered {
	position: absolute;
	clip: rect(0px 1px 1px 0px);
	clip: rect(0px, 1px, 1px, 0px);
}
.${name}-credit .bigbtn, .${name}-bank .bigbtn {
	float: left;
	width: 280px;
}
#${name}-content .callus {
	padding: 9px 0 0 295px;
	font-size: 15px;
}
#${name}-content, #${name}-dialog, .${name}-launchers, .${name}-fails, .${name}-success, .${name}-credit, .${name}-bank {
	display: none;
}
body.${name}-active #${name}-content {
	display: block;
}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var paymentGateway = {

	name: '${name}',
	handledType: {},
	_hasRegistered: false,
	_type: '',
	_calledBack: false,

	hasRegistered: function() {
		return this._hasRegistered;
	},
	
	success: function() {
		this._hasRegistered = true;
		this._outcome(true);
		$('#${name}-registered').val('1').valid();
		$('.${name}-success').slideDown();
		$('.${name}-fails').slideUp();
	},
	
	fail: function(_msg) {
		this._outcome(false);
		$('#${name}-registered').val('');
		$('.${name}-success').slideUp();
		$('.${name}-fails').slideDown();
		
		if (_msg && _msg.length > 0) {
			if (typeof(FatalErrorDialog) != 'undefined') {
				FatalErrorDialog.register({
					message:		_msg,
					page:			'health_quote.jsp',
					description:	'paymentGateway.fail()'
					});
			}
		}
	},
	
	_outcome: function(success) {
		this._calledBack = true;
		$('.${name}-launchers').slideUp();
		$('#${name}-dialog').dialog('close');
	},
	
	setType: function(type) {
		if (this._type != type) {
			 this._hasRegistered = false;
		}
		if ((type == 'cc' && this.handledType.credit) || (type == 'ba' && this.handledType.bank)) {
			this._type = type;
		}
		else {
			this._type = '';
		}
		this.togglePanels();
		return (this._type != '');
	},
	
	setTypeFromControl: function() {
		this.setType(paymentSelectsHandler.getType());
	},
	
	togglePanels: function() {
		if (this.hasRegistered()) {
			$('.${name}-launchers').slideUp();
			$('.${name}-success').slideDown();
			$('.${name}-fails').slideUp();
		}
		else {
			$('#${name}-registered').val('');
			$('.${name}-launchers').slideDown();
			$('.${name}-success').slideUp();
			$('.${name}-fails').slideUp();
		}
		
		switch (this._type) {
			case 'cc':
				$('.${name}-credit').slideDown();
				$('.${name}-bank').slideUp('','', function(){ $(this).hide(); });
				$('#health_payment_credit-selection').hide();<%-- Hide normal question --%>
				break;
			case 'ba':
				$('.${name}-credit').slideUp('','', function(){ $(this).hide(); });
				$('.${name}-bank').slideDown();
				$('#health_payment_bank-selection').hide();<%-- Hide normal question --%>
				break;
			default:
				$('.${name}-credit').slideUp('','', function(){ $(this).hide(); });
				$('.${name}-bank').slideUp('','', function(){ $(this).hide(); });
		}
	},
	
	<%-- Reset settings and unhook --%>
	reset: function() {
		this.handledType = {'credit': false, 'bank': false };
		this._type = '';
		this._hasRegistered = false;
		this.togglePanels();
		
		$('body').removeClass('${name}-active');
		$('#${name}-registered').rules('remove', 'required');
		$('#${name}-registered').val('');
		
		<%-- Turn off events --%>
		$('#health_payment_details_claims').find('input').off('change.${name}');
		$('#update-step').off('click.${name}');
		
		<%-- Reset normal question panels in case user is moving between different products --%>
		$('#health_payment_details_type').trigger('change');
	},
	
	init: function() {
		this.reset();

		$('body').addClass('${name}-active');
		$('#${name}-registered').rules('add', {required:true, messages:{required:'Please register your payment details'}});

		var __this = this;
		
		<%-- Hook into: supply bank account for claims --%>
		$('#health_payment_details_claims').find('input').on('change.${name}', function() {
			var show = ($('#health_payment_details_claims').find('input:checked').val() == 'Y');
			paymentSelectsHandler._renderClaims(false, show);<%-- _claimsQuestion, _claimsDetails --%>
		});
		<%-- Hook into: "update premium" button to determine which panels to display --%>
		$('#update-step').on('click.${name}', function() {
			__this.setTypeFromControl();
		});
		
		$('#${name}-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip',
			'modal':true,
			'width':637, 'height':450,
			'draggable':true,
			'resizable':false,
			'dialogClass': '${name}-dialog',
			'title':'Register your details',
			open: function() {
				$('.ui-widget-overlay').on('click.${name}', function () { $('#${name}-dialog').dialog('close'); });
			},
			close: function() {
				$('.ui-widget-overlay').off('click.${name}');
				$('#${name}-dialog').html('');
				if (!__this._calledBack) {
					__this.fail();
				}
			}
		});
	},
	
	<%--- DIALOG ---%>
	launch: function() {
		this._calledBack = false;
		var type = '';
		if (this._type == 'ba') {
			type = 'DD';<%-- For westpac --%>
		}
		$('#${name}-dialog').html('<iframe width="100%" height="340" src="ajax/html/health_paymentgateway.jsp?type=' + type + '"></iframe>');
		$('#${name}-dialog').dialog('open');
		Track.onCustomPage('Payment gateway popup');
	},
};

</go:script>

<%-- JAVASCRIPT --%>
<go:script marker="onready">
</go:script>
