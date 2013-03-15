<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<go:script marker="onready">
	// Supertag tracking
	Track.onQuoteEvent("Start", ReferenceNo.getTransactionID());
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
