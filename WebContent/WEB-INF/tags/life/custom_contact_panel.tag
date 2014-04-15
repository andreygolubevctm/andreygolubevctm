<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="onready">

	var CallNowPanel = new Object();
	CallNowPanel = {

		render : function( simple ) {
			simple = simple || false;

			$("#contact-panel").find(".row.mid").first().empty().append("<div class='lifebroker-contact-panel'><div class='option call-us-now'></div><a href='javascript:LifeQuote.onRequestCallback();' class='option call-me-back'></a></div>");

			if( !simple && QuoteEngine.validate() ) {
				CallNowPanel.renderDetail();
			} else {
				CallNowPanel.renderSimple();
			}
		},

		renderDetail : function() {
			$("#contact-panel").addClass("extended");
		},

		renderSimple : function() {
			$("#contact-panel").removeClass("extended");
		}
	};

	CallNowPanel.render( true );

	slide_callbacks.register({
		mode:			'before',
		slide_id:		-1,
		callback:		function(){
			CallNowPanel.render( QuoteEngine._options.currentSlide == 0 || QuoteEngine._options.currentSlide == 3 );
			$('html, body').animate({ scrollTop: 0 }, 'fast');
		}
	});
</go:script>

<go:style marker="css-head">
#contact-panel,
#contact-panel .row,
#lifebroker-contact-panel {
	background-image:		none !important;
	background-color:		transparent !important;
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr=#ccffffff,endColorstr=#ccffffff) !important;
	zoom: 1 !important;
}
</go:style>