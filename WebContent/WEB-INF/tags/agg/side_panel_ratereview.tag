<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- HTML --%>

	<%-- trigger --%>
<a id="sideRateReviewPanel" href="javascript:RateReviewDetailDialog.launch();" title="Click to learn how to protect yourself from rising health insurance premium."><!-- empty --></a>

	<%-- dialog --%>
<div id="ratereview-detail-dialog" class="ratereview-detail-dialog" title="How to protect yourself from rising health insurance premiums">
	<div class="innertube"><!-- populate by template --></div>
	<div class="dialog_footer"></div>
</div>

	<%-- template --%>
<core:js_template id="ratereview-detail-content">
<h2>How to protect yourself from rising health insurance premiums?</h2> 
<p>Rate rises in the health industry happen every year, but did you know there&#39;s a way to save money even in the face of increasing health insurance costs?</p>
<p>Health funds generally apply the rate rise on the first of April each year, so you have a window in which to <strong>lock in the previous year&#39;s rate</strong> by paying a <strong>year of premiums in advance</strong>. This means you can avoid paying the increased health insurance premium for at least 12 months.</p>
<p>In order to lock in the cheaper rate and save money, you need to:</p>
<ul>
	<li>start your policy before the 1st April</li>
	<li>find out if your health fund has a cut&#45;off date, as some health funds require your payment to be made by a certain date in order to lock in the lower rate (e.g. 25th March). Give us a call on <strong>1800 77 77 12</strong> or chat online today, and we&#39;ll be able to assist you</li>
	<li>ensure your payment is processed by the bank and reaches the health fund by the 1st April (please note that it can take up to 6 days for payments to be processed,  so be sure not to leave it too late).</li>
</ul>
</core:js_template>

<%-- CSS --%>
<go:style marker="css-head">
	#sideRateReviewPanel {
		display:			block;
		width:				293px;
		height:				197px;
		margin:				0 auto;
		background:			transparent url() top left no-repeat;
	}
	
	
	#ratereview-detail-dialog {
		min-width:				637px;
		max-width:				637px;
		width:					637px;
		display: 				none;
		overflow:				hidden;
	}
	#ratereview-detail-dialog .clear{clear:both;}
	
	#ratereview-detail-dialog .innertube {
		margin:					0 20px 30px 20px;
	}
	
	#ratereview-detail-dialog h2 {
		font-size:				16px;
		font-weight:			900;
		margin:					0 0 15px 0;
	}
	
	#ratereview-detail-dialog h3,
	#ratereview-detail-dialog p,
	#ratereview-detail-dialog li {
		font-size:				14px !important;
	}
	
	#ratereview-detail-dialog h3 {
		font-weight:			900;
		margin:					15px 0 5px 0;
	}
	
	#ratereview-detail-dialog h3:first-child {
		margin-top:				0;
	}
	
	#ratereview-detail-dialog p {
		margin:					8px 0;
		font-size:				13px;
		line-height:			15px;
	}
	
	#ratereview-detail-dialog li {
		list-style-type: 		disc;
		margin-left: 			30px;
		padding: 				2px 0 !important;
	}
	
	#ratereview-detail-dialog ol li {
		list-style-type: 		decimal;
	}
	
	#ratereview-detail-dialog .innertube th,
	#ratereview-detail-dialog .innertube td {
		padding:				5px 10px;
		border:					1px solid #E3E8EC;
		text-align:				left;
	}
	
	#ratereview-detail-dialog .innertube th {
		font-weight:			900;
	}
	
	#ratereview-detail-dialog .dialog_footer {
		position:				absolute;
		left:					0;
		bottom:					0;
		background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
		width: 					637px;
		height: 				14px;
		clear: 					both;
	}
	
	.ui-dialog.ratereview-detail-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
		display: 				block !important;
		top: 					2.5em !important;
		right: 					1em;
	}
	.ui-dialog.ratereview-detail-dialog .message-form, .ui-dialog #ratereview-detail-dialog{
		padding:				0;
	}
	
	.ratereview-detail-dialog .ui-dialog-titlebar {
		background-image:		url("common/images/dialog/header_637.gif") !important;
		height:					34px;
		-moz-border-radius-bottomright: 0;
		-webkit-border-bottom-right-radius: 0;
		-khtml-border-bottom-right-radius: 0;
		border-bottom-right-radius: 0;
		-moz-border-radius-bottomleft: 0;
		-webkit-border-bottom-left-radius: 0;
		-khtml-border-bottom-left-radius: 0;
		border-bottom-left-radius: 0;
	}
	
	.ratereview-detail-dialog .ui-dialog-content {
		background-image:		url("brand/ctm/images/ui-dialog-content_637.png") !important;
	}
	
	.ui-dialog.ratereview-detail-dialog .ui-dialog-title {
		font-size: 20px !important;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var RateReviewDetailDialog = new Object();
RateReviewDetailDialog = {

	tpl : 'ratereview-detail-content',

	init: function()
	{
		// Initialise the search quotes dialog box
		// =======================================
		$('#ratereview-detail-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip', 
			'modal':true, 
			'width':637, 'height':'auto', 
			'minWidth':637/*, 'minHeight':715*/,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'ratereview-detail-dialog',
			'title':'Hint Dialog Title.',
			open: function() {
				RateReviewDetailDialog.show(); 
				$('.ui-widget-overlay').bind('click', function () { $("#ratereview-detail-dialog").dialog('close'); });
			},
			close: function(){
				RateReviewDetailDialog.hide();	
		  	}
		});	
	},
	
	launch: function()
	{
		if( $('#ratereview-detail-dialog').dialog("isOpen") )
		{
			$('#ratereview-detail-dialog').dialog("close");
		}
		
		if( $('#ratereview-detail-content') )
		{
			$('#ratereview-detail-dialog').find(".innertube").first().empty().append(
				$('#ratereview-detail-content').html()
			);
			$('#ratereview-detail-dialog').dialog("option", "title", $('#ratereview-detail-dialog .innertube').find('h2').first().hide().html());
			$('#ratereview-detail-dialog').dialog("open");
		}
		else
		{
			FatalErrorDialog.exec({
				message:		"Requested content doesn't exist.",
				page:			"health:popup_hintsdetail.tag",
				description:	"RateReviewDetailDialog.launch(). Could not find element with ID: #ratereview-detail-content",
				data:			null
			});
		}
	},
	
	hide: function()
	{
		$("#ratereview-detail-dialog").hide();
	},

	show: function()
	{
		$("#ratereview-detail-dialog").show();
	}
};

RateReviewDetailDialog.addContent


</go:script>
<go:script marker="onready">
RateReviewDetailDialog.init();
</go:script>