<%@ tag description="Terms and conditions popup for results page"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var PricesChangedNote = new Object();
	PricesChangedNote = {
		origZ : '',
		show : function( callback ) {
			Popup.show("#quick_note", "#loading-overlay");
			$('#quick_note .primary-button , .closeQuickNote').click(function() {
				PricesChangedNote.hide();
			});
			$('#quick_note .secondary-button').click(function() {
				PricesChangedNote.hide();
				Results.hidePage();
				QuoteEngine.gotoSlide({'noAnimation':true, 'index':0});
			});
		},
		hide: function() {
			Popup.hide("#quick_note");
			$('#quick_note primary-button').unbind('click');
			$('#quick_note secondary-button').unbind('click');
		}
	}
</go:script >
<%-- CSS --%>
<go:style marker="css-head">
	.closeQuickNote {
		left: auto;
		float: right;
		display: block;
		position: relative;
		top: 0px;
		background: url("common/images/dialog/close.png") no-repeat scroll 0 0 transparent;
		height: 34px;
		width: 36px;
	}
	#quick_note .primary-button {
		margin: auto;
		display: block;
		margin-bottom: 1em;
		width:200px;
	}

	#quick_note p {
		margin-top: 1em;
		margin-bottom: 1em;
		line-height: 1.4em;
	}

	#quick_note .strong {
		font-weight: 600 !important;
	}

	#quick_note {
		max-width: 500px;
		width: 100%;
		margin: auto;
		background-color: #FFFFFF;
		padding: 1em;
		border-radius: 7px;
	}

</go:style>
<%-- HTML --%>
<div id="quick_note" class="popup" >
	<a href="javascript:void(0);" class="closeQuickNote"></a>
	<h5 class="blueHeading strong">Just a quick note</h5>
		<div class="content" >
			<p>
				There have been some updates to our products since you last visited us.
				Here's the latest products based on your previously entered preferences.
				Hurry, buy now and don't miss out.
			</p>
			<p>
			Call our friendly team on <span class="callUsInline strong">1800 777712</span> for
			professional help on selecting the right health policy for you or
				<a href="javascript:void(0);" class="secondary-button strong">start a new quote</a>.
		</p>
	</div>
	<div class="buttons" >
			<button class="primary-button enabled" type="button"><span>Show latest results &gt;</span></button>
	</div>
</div>