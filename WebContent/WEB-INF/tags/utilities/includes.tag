<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="utilities" />

<quote:save_quote quoteType="${vertical}" mainJS="UtilitiesQuote" />

<%-- Apply Online Popup --%>
<utilities:apply_online />

<%--Dialog panel for editing provider plan --%>
<utilities:popup_providerplans />

<go:script marker="onready">
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

<form:radio_button_group_validate />

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />
