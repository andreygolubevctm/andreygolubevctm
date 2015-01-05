<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<go:script marker="onready">

	var CallNowPanel = new Object();
	CallNowPanel = {

		render : function( ) {

			$("#contact-panel").find(".row.mid").first().empty().append("<div class='thoughtworld-contact-panel'><div class='option call-us-now'></div></div>");
		},

	};

	CallNowPanel.render( true );


</go:script>

<go:style marker="css-head">
#contact-panel,
#contact-panel .row,
#thoughtworld-contact-panel {
    font-size: 160%;
    line-height: 67px;
    color: #1c3e93;
	background-image:		none !important;
	background-color:		transparent !important;
}
</go:style>