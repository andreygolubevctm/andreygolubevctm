<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="utilities" />

<%--<quote:save_quote quoteType="${vertical}" mainJS="UtilitiesQuote" /> --%>

<%-- Apply Online Popup --%>
<utilities_v1:apply_online />

<%-- Discount Popup --%>
<utilities_v1:discount />

<%--Dialog panel for editing provider plan --%>
<utilities_v1:popup_providerplans />

<go:script marker="onready">
	<utilities_v1:custom_contact_panel />
	// Supertag tracking
	Track.onQuoteEvent("Start", referenceNo.getTransactionID(true));
	Track.nextClicked(0);

	slide_callbacks.register({
		mode:		'before',
		slide_id:	-1,
		callback:	function(){
			$('html, body').animate({ scrollTop: 0 }, 'fast');
		}
	});

	$(document).on('click','a[data-savequote=true]',function(){
		SaveQuote.show();
	});
</go:script>

<form_v1:radio_button_group_validate />

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />
