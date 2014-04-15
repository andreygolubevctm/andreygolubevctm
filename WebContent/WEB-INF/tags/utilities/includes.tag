<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

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
</go:script>

<go:script marker="js-href" href="common/js/jquery.formatCurrency-1.4.0.js" />
