<%@ tag description="The Results"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>


<%-- PRE-SET --%>
<c:if test="${empty data['health/show-price'] || data['health/show-price'] == ''}">
	<go:setData dataVar="data" xpath="health/show-price" value="M"  />
</c:if>
<c:if test="${empty data['health/rank-by'] || data['health/rank-by'] == ''}">
	<go:setData dataVar="data" xpath="health/rank-by" value="B"  />
</c:if>


<go:script marker="jquery-ui">
	$('#results-read-more').dialog({
		title: 'About the fund',
		autoOpen: false,
		show: 'clip',
		hide: 'clip',
		'modal':true,
		'width':637,
		'minWidth':637, 'minHeight':250,
		'autoOpen': false,
		'draggable':false,
		'resizable':false,
		'dialogClass':'results-about-dialog',
		open: function() {
			$('.ui-widget-overlay').bind('click', function () { $('#results-read-more').dialog('close'); });
		}
	});
</go:script>


<!--[if IE 7]>
<style type="text/css">
.pagination {
	margin-top: -15px !important;
}
</style>
<![endif]-->

<%-- CSS --%>
<go:style marker="css-head">
#results-divider {
	position:relative;
	overflow:visible;
}
.results-about-dialog .ui-dialog-titlebar-close.ui-corner-all {
	display:block;
}
#resultsPage {
	display:none;
}
#header.resultsPage {
	z-index:10;
}
#resultsPage {
	margin-left: auto;
	margin-right: auto;
	position: relative;
	width: 980px;
	height:2450px;
	background: url(brand/ctm/images/speckle.png);
}
<c:if test="${not empty callCentre}">
.callcentre #resultsPage {
	padding-top: 55px;
}
</c:if>
#results-summary {
	height: 60px;
	padding-top:30px;
	line-height: 2px;
}
#results-bar {
	width: 900px !important;
	height:33px;
	z-index:49;
	position:absolute;
	background: none !important;
	z-index: 100;
	top: 160px;
	margin-top: 40px !important;
}

#results-fixed.extended #results-bar {
	position: absolute;
	top: 600px;
}

.health.FixedResults #results-fixed #results-bar {
	position: fixed;
	top: 28px;
}

#results-bar h3 {
	display: inline-block;
	float: left;
	text-shadow: 1px 1px #fff;
	margin-left: 10px;
	line-height: 34px;
}
	#results-bar .pagination {
		float:right;
		right: 100px;
		margin-right: -50px !important;
	}
	#results-bar .pagination img {
		margin-top: -8px !important;
	}
	#results-fixed.extended #results-bar .pagination img {
		margin-top: -8px !important;
	}
	#results-bar h4 {
		float:left;
		line-height:34px;
	}
	#results-bar .pagination .disabled {
		opacity:.5;
	}

#basket {
	width: 216px;
	height: 254px;
	left: 0;
	position: absolute;
	z-index:10;
	top: 248px;
}

#results-fixed.extended #basket {
	position: absolute;
	top: 691px;
}

.health.FixedResults #results-fixed #basket {
	top: 103px;
	left: auto;
	position: fixed;
}

#basket a.btn {
	display:				block;
	width:					181px;
	height:					33px;
	background:				transparent url("brand/ctm/images/button_bg_bl.png") top left no-repeat;
	cursor:pointer: 		cursor:hand;
	margin:					0;
	padding:				0 0 5px 0;
	text-decoration: 		none;
}

#basket a.btn span {
	display: 				block;
	color: 					#ffffff;
	font-size:				11.25pt;
	font-weight:			bold;
	background: 			transparent url("brand/ctm/images/button_bg_sml_bl.png") top right no-repeat;
	height: 				100%;
	width: 					100%;
	line-height: 			33px;
	margin:					0;
	padding:				0;
	text-align: 			center;
	text-shadow: 			0px 1px 1px rgba(0,0,0,0.5);
}

#basket .row {
	width:					auto;
	padding:				0 15px;
	background-color:		transparent;
	background-position:	top left;
	background-repeat:		no-repeat;
}

#basket .row.top {
	height:					5px;
	background-image:		url(brand/ctm/images/left_panel_top.png);
}

#basket .row.mid {
	height:					246px;
	background-repeat:		repeat-y;
	background-image:		url(brand/ctm/images/left_panel_mid_lt.png);
}

.hasAltPremium #basket .row.mid {
	height: 235px;
}

#basket .row.bot {
	height:					5px;
	background-position:	bottom left;
	background-image:		url(brand/ctm/images/left_panel_bot_lt.png);
}

#basket h4 {
	padding:				15px 0 5px 0;
}

#basket .content {
	padding:				5px 0;
}

#basket .item {
	cursor: pointer;
}

#results-header {
	height:256px;
	left: 230px;
	position: absolute;
	width: 750px;
	overflow:hidden;

	background-image: url(brand/ctm/images/speckle.png) !important;
	top: 248px;
	margin-left: 0;
}
#results-fixed.extended #results-header {
	position: absolute;
	top: 691px;
}
.health.FixedResults #results-fixed #results-header {
	position: fixed;
	left: auto;
	top: 103px;
	z-index: 99;
	margin-left: 230px;
}
.hasAltPremium #results-header {
	height:245px;
}

.page p{
	color: #4a4f51 !important;
}

.active p {
	color: #E54200 !important;
}

#HLT_MainLeft,
#HLT_MainRight {
	float:left;
	font-size:1.5em;
	width: 28px;
	height: 28px;
	color: #999 !important;
	margin-right: 0;
	background: url(brand/ctm/images/results/results_navArrowsSprite.png) 0 0;
}

#HLT_MainLeft {
	background-position: 0 0;
}

#HLT_MainLeft:hover {
	background-position: 0 -28px;
}

#HLT_MainRight {
	background-position: -28px 0;
}

#HLT_MainRight:hover {
	background-position: -28px -28px;
}

#HLT_MainLeft.disabled, #HLT_MainLeft.disabled:hover {
	background-position: 0 -56px;
	cursor: default !important;
}

#HLT_MainRight.disabled, #HLT_MainRight.disabled:hover {
	background-position: -28px -56px;
	cursor: default !important;
}

#results-fixed {
	background:#fff;
	width: 980px;
	z-index: 10;
	padding-bottom: 0px;
}

#results-fixed #results-fixed-mask {
	position: fixed;
	background:#fff;
	width: 980px;
	height: 58px;
	z-index: 299;
	top:0;
	display: none;
}
.health.FixedResults #results-fixed #results-fixed-mask {
	display:block !important;
}

#results-header .current-results {
	height: 276px;
	left: 40px;
	overflow: hidden;
	position: absolute;
	top:0;
	width: 10000px;
	z-index:50;
}
.hasAltPremium #results-header .current-results {
	height: 200px;
}
#results-header .current-results > div {
	position:relative;
	float: left;
	width: 224px;
	height: 110px;
	padding-top:60px;
	margin-right:8px;
}
	.comparing #results-header .current-results > div {
		left:auto !important;
	}
	#results-header .current-results > div.filtered {
		display:none !important;
	}
#results-container {
	width:10000px;
	height:2450px;
	left: 0px;
	overflow: hidden;
	position: absolute;
	clip:rect(auto, 980px, auto, auto);
}
#results-table {
	left: 230px;
	position: absolute;
	width: auto;
	overflow:hidden;
}
#results-table .current-results {
	position:relative;
	left:0px;
}
#results-table .current-results > div {
	float: left;
	width: 226px;
	margin-right:8px;
	position:relative;
}
	.comparing #results-table .current-results > div {
		left:auto !important;
	}
	#results-table .current-results > div.filtered {
		display:none !important;
	}
#left-panel {
	position: absolute;
	width: 215px;
	z-index:5;
	top: 356px;
}
#results-container.extended #left-panel{
	top: 352px;
}
.hasAltPremium #left-panel {
	top:285px;
}
#results-table .promotions {
	height: 100px;
	width: 205px;
}
#results-table .policy-snapshot {
	height: 200px;
	width: 205px;
}
#results-table .change-excess {
	height: 100px;
	width: 205px;
}
#results-table .about-fund {
	height: 100px;
	width: 205px;
}
#left-panel .category-extras {
	width: 215px;
}
#left-panel .category-hospital {
	width: 215px;
}
#matchCategoryHospital,
#matchCategoryExtras,
#matchCategoryAmbulance,
#matchCategoryAdditional {
	margin-bottom:24px;
}
.matchDataDetails,
.matchDataHospital,
.matchDataExtras,
.matchDataAmbulance,
.matchDataAdditional {
	margin-bottom:24px;
}
#matchCategoryHospital h5,#matchCategoryHospital h6,
#matchCategoryExtras h5,#matchCategoryExtras h6,
#matchCategoryAmbulance h5,#matchCategoryAmbulance h6,
#matchCategoryAdditional h5, #matchCategoryAdditional h6 {
	margin-left:15px;
	margin-right:15px;
}
h6.longLabel {
	letter-spacing: -0.2px;
}
.all-extras {
	width: 215px;
}
.expandable {
	cursor:pointer;
}
.expandable p {
	display:none;
	position: relative;
	width:100%;
}
.expandable.open p {
	display:block;
}
#left-panel .box {
	width:					216px;
	padding:				0;
	margin:					0 0 10px 0;
}

#left-panel .box h4 {
	font-size: 				15pt;
	padding:				10px 0 5px 0;
}

#left-panel h5, #current-results .result-row h5  {
	font-size: 				14px;
}

#left-panel .box h5.lt {
	position:				relative;
	padding:				5px 0;
}

#left-panel .box h5.lt span {
	position:				absolute;
	width:					15px;
	height:					15px;
	right:					0;
	top:					3px;
	cursor:					pointer;
}

#left-panel .box.ambulance h5 a,
#left-panel .box h6 a {
	position:				absolute;
	width:					14px;
	height:					14px;
	<!-- right:					0; -->
	left: 					-14px;
	top:					0;
}

#left-panel .box h4  {
	position:				relative;
	padding:				7px 0;
}

#left-panel .box h6 {
	position:				relative;
}

#left-panel .box .row {
	width:					auto;
}

#left-panel .box .row.top {
	height:					5px;
}

#left-panel .box .row.mid {
	width:					216px;
	padding:				14px 0px 10px 0px;
	overflow:				auto;
}

#left-panel .box.filter-selection .row.mid {
	width:					186px;
	padding:				14px 15px 10px 15px;
}

#left-panel .box .row.bot {
	height:					5px;
}

#left-panel .box .row > div {
	position:				relative;
	margin:					0 auto;
}

#left-panel .box .row .item {
	font-size:				9.75pt;
}

#left-panel .box .row .item a {
	position:				absolute;
	width:					14px;
	height:					14px;
}
#left-panel .msg {
	font-size:9px;
}
#left-panel .edit-selection .row.mid {
	width:					206px;
	height:					40px;
	padding: 				10px 5px 5px 5px;
	overflow: hidden;
}

#left-panel .edit-selection a {
	float:					left;
	width:					98px;
	height:					33px;
	cursor:pointer: 		cursor:hand;
	margin:					2px;
	padding:				0;
	text-decoration: 		none;
}

#left-panel .edit-selection a span {
	display: 				block;
	font-size:				9.5pt;
	font-weight:			bold;
	height: 				100%;
	width: 					100%;
	line-height: 			33px;
	margin:					0;
	padding:				0;
	text-align: 			center;
}

#resultsPage .edit_benefits {
	display:				block;
}

#left-panel .exclusions_cover {
	padding: 11px 15px 0;
	height: 90px;
}
#results-table .exclusions_cover {
	height: 90px;
}
.exclusions_cover {
	color: red;
}

#left-panel #show-price label,
#left-panel #rank-results-by label {
	padding-right:60px;
	margin-bottom:2px;
}

#left-panel #show-price label,
#left-panel #rank-results-by label {
	border:					none !important;
	height:					20px;
}

#left-panel #show-price .radio-icon,
#left-panel #rank-results-by .radio-icon {
	width:					20px;
	height:					19px;
}

#left-panel #show-price .ui-button-text,
#left-panel #rank-results-by .ui-button-text {
	padding-left:			2.7em !important;
	padding-right:			0 !important;
}

#left-panel .help_icon {margin:0 !important;}

#left-panel .filter-selection #change-excess .slider,
#left-panel .filter-selection #change-price-min .slider {
	width:160px;
	height:20px;
	margin-left:0px;
	border-width:0px;
	cursor:pointer;
	cursor:hand;
}

#left-panel .filter-selection #change-excess .sliderWrapper,
#left-panel .filter-selection #change-price-min .sliderWrapper {
	margin-top:12px;
	margin-bottom:0px;
}
#left-panel .filter-selection #change-excess .sliderWrapper label,
#left-panel .filter-selection #change-price-min .sliderWrapper label {
	font-weight: bold;
	font-size: 11px;
}
#left-panel .filter-selection #change-excess .sliderWrapper span,
#left-panel .filter-selection #change-price-min .sliderWrapper span {
	font-size: 11px;
}
#left-panel .filter-selection #change-excess .help_icon,
#left-panel .filter-selection #change-price-min .help_icon {
	display:				none;
}
#left-panel .filter-selection #change-excess .ui-slider-handle,
#left-panel .filter-selection #change-price-min .ui-slider-handle {
	border: none;
	height: 21px;
	width: 23px;
	padding: 0;
	margin-left: 0px;
	margin-top: 5px;
	cursor:e-resize;
}

#left-panel #show-price,
#left-panel #rank-results-by,
#left-panel #change-excess {
	display:				none;
}

#left-panel #show-price.open,
#left-panel #rank-results-by.open,
#left-panel #change-excess.open {
	display:				block;
}

h5.canExpand {
	color:black;
}

/* EDIT BENEFITS DIALOG */

#results-edit-benefits {
	display:				none;
	overflow:				hidden;
}

#results-edit-benefits #health_benefits-selection {
	position:				relative;
	width:					607px;
	height:					530px;
	overflow:				auto;
}

#results-edit-benefits #health_benefits .columns .qe-window {
	width:					284px;
	margin-top:				0px;
}

#results-edit-benefits #health_benefits .columns .qe-window .content {
	width:					264px;
}

#results-edit-benefits #health_benefits .columns input {
	float:					none;
	position:				absolute;
	right:					10px;
	top:					5px;
}

#results-edit-benefits #health_benefits .columns label {
	margin:					0;
	padding:				10px 0 5px 24px;
	display:				inline-block;
	width:					213px;
	float:					none;
}

#results-edit-benefits #health_benefits h2,
#results-edit-benefits #health_benefits p,
#results-edit-benefits #health_benefits .fieldrow.health-benefits-healthSitu-group {
	display:				none;
}

#results-edit-benefits #health_benefits .columns.col1of2 {
	margin-right: 			20px;
}

#results-edit-benefits #health_benefits .columns {
	position: 				relative !important;
}

#results-edit-benefits .dialog_footer {
	position: 				absolute;
	left: 					0;
	bottom: 				0;
	background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
	width: 					637px;
	height: 				14px;
	clear: 					both;
}

#ui-dialog-title-results-edit-benefits {
	font-family:			"SunLT Bold",Arial,Helvetica,Sans-serif;
	font-size:				20px;
}

.results-edit-benefits-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display:				block !important;
	right:					1.5em !important;
	top:					2.5em !important;
}

/* READ-MORE DIALOG */

#results-read-more {
	display:				none;
}

#ui-dialog-title-results-read-more {
	font-family:			"SunLT Bold",Arial,Helvetica,Sans-serif;
	font-size:				20px;
}

/* COMMON TO ALL DIALOGS */

.ui-dialog-titlebar a.ui-dialog-titlebar-close {
	right:					1em !important;
	top:					2em !important;
}

#viewMoreProducts {
	left: 60%;
	position: absolute;
	font-weight: bold;
	top: 10px;
}

#HLT_InPageRight, #HLT_InPageLeft {
	cursor: pointer !important;
	width: 60px;
	margin-left: 920px;
	position: absolute;
	z-index: 100;
	margin-top: 75px;
	min-height: 2270px;
	float: left;
	clear: left;
	background-image: -webkit-gradient(linear, left top, right top, color-stop(0, #fff), color-stop(1, #ddd));
	background-image: -ms-linear-gradient(left, #FFFFFF 0%, #DDDDDD 100%);
	background-image: -moz-linear-gradient(left, #FFFFFF 0%, #DDDDDD 100%);
	background-image: linear-gradient(to right, #FFFFFF 0%, #DDDDDD 100%);
	background: url(brand/ctm/images/shadow.png) repeat-y;
	background-repeat: repeat-y
	background-attachment: fixed;
	top: 173px;
}

#HLT_InPageLeft {
	margin-left: 228px !important;
	background: url(brand/ctm/images/shadow_reverse.png) repeat-y !important;
	position: absolute;
	display: none;
}

#results-fixed.extended #HLT_InPageRight, #results-fixed.extended #HLT_InPageLeft {
	position: absolute;
	top: 616px;
}

.health.FixedResults #results-fixed #HLT_InPageRight, .health.FixedResults #results-fixed #HLT_InPageLeft {
	position: fixed;
	top: 28px;
}

#nextPageSlider {
	position: absolute;
	right: 2px;
	top: 300px;
	cursor: pointer;
	height: 41px;
	color: #fff;
	width: 30px;
	background-image: url(brand/ctm/images/next_page.png);
	background-repeat: no-repeat;
	opacity: 0.4;
}

#prevPageSlider {
	position: absolute;
	right: 28px;
	top: 300px;
	cursor: pointer;
	height: 41px;
	color: #fff;
	width: 30px;
	background-image: url(brand/ctm/images/prev_page.png);
	background-repeat: no-repeat;
	opacity: 0.4;
}

#nextPageSlider:hover, #prevPageSlider:hover,
#HLT_InPageRight:hover #nextPageSlider,
#HLT_InPageLeft:hover #prevPageSlider{
	opacity: 1;
}

.hoverrow {
	background-color: #DCECFC !important;
}

#footer, #copyright {
	z-index: 200;
	position:relative;
}

#results-container h3 {
	text-shadow: 1px 1px #fff;
	font-size: 26px;
	margin-top: 20px;
	margin-left: 10px;
}

.thinFont {
	font-family: 'SunLt Light', sans-serif;
	font-weight: normal;
	text-shadow: 1px 1px #fff;
}

#compareMask {
	height: 70px;
	width: 980px;
	position: absolute;
	background: url(brand/ctm/images/speckle.png);
	top: -70px;
	xborder: 1px solid #f0f;
}

.simplesTooltips{
	background-color: #ffffff;
	border: 5px solid green;
	padding: 5px;
	font-size: 15px;
	color: darkgrey;
	line-height: 15px;
}
.premium[data-hasqtip=true]{
	cursor: pointer;
}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var preShadowState = 'none', nextShadowState = 'none';

<%-- Registering the slide for when user tabs back --%>
slide_callbacks.register({
	mode:		'after',
	direction: 'reverse',
	slide_id:	2,
	callback:	function() {
		Results.revisit();
	}
});

slide_callbacks.register({
	mode:		'after',
	direction: 'forward',
	slide_id:	2,
	callback:	function() {
		hints.clear();
	}
});



<%-- Create an object that can 'fix' the main headings to the top of the page --%>
var FixedResults = {
	_top: 0,
	_active: false,

	init: function(){
		$(window).on('scroll.FixedResults', FixedResults._check);
	},
	destroy: function(){
		$('body').removeClass('FixedResults');
		FixedResults._active = false;
		$(window).off('scroll.FixedResults');
	},
	updateTop: function() {
		FixedResults._top = $('#results-container').offset().top - 18;
		FixedResults._top = Math.floor(FixedResults._top);
	},
	_check:function(){
		if(FixedResults._top != 0){
			var scroll_top = FixedResults.scrollTop();

			if( FixedResults._active === false && scroll_top > FixedResults._top ) {
				$('body').addClass('FixedResults');

				$('.pagination img').hide();

				FixedResults._active = true;

			} else if( FixedResults._active === true && scroll_top < FixedResults._top ) {

				$('.pagination').css('margin-left', '-50px');

				$('body').removeClass('FixedResults');

				$('.pagination img').show();
				FixedResults._active = false;
			};
		};
	},
	scrollTop: function() {
		if ($(window).hasOwnProperty("scrollTop")) {
			return $(window).scrollTop();
		}
		else {
			return $(document).scroll().scrollTop();
		}
	}
};

var Compare = {
	_max: 3,
	_active: 0,

	bind: function(){
		<%-- NOTE: Binds have been moved to delegation in onready --%>
		Compare.reset();
	},

	addRemove: function(id){
		if( Compare.addItem(id) ) {
			Compare._$hdr.find('.result-row[data-id="'+ id +'"] .compare').addClass('compare-on');
		} else if( Compare.removeItem(id) ) {
			Compare._$hdr.find('.result-row[data-id="'+ id +'"] .compare').removeClass('compare-on');
		};
	},

	addItem: function(id){
		if(Compare._active >= Compare._max){
			return false;
		} else if( $('#basket').find('.item[data-id="'+ id +'"]').length == 0  ) {
			//create elements
			var $obj =  Compare._$hdr.find('.result-row[data-id="' + id + '"]');
			var html = '<div class="item" data-id="'+ id +'"><strong>'+ $obj.find(".premium strong").text() +'</strong><span>'+ $obj.find(".thumb img").attr('alt') + '</span><a href="javascript:void(0);">remove</a></div>';

			//append HTMLs and Bind
			Compare._$basket.find('.basket-items').append(html);
			Compare._$basket.find('.item[data-id="'+ id +'"]').on('click', function(){ Compare.addRemove(id) });

			//can button be used?
			Compare._active++;
			Compare._status();
			return true;
		};
		return false;
	},

	removeItem: function(id){
		if( Compare._$basket.find('.item[data-id="'+ id +'"]').length == 1 && !Compare._$basket.hasClass('comparing') ){
			Compare._$basket.find('.item[data-id="'+ id +'"]').remove();
			Compare._active--;
			Compare._status();
			return true;
		};
		return false;
	},

	reset: function(id){
		//set the starting vars
		Compare._$hdr = $('#results-header'),
		Compare._$basket = $('#basket'),
		Compare._$table = $('#results-table'),

		//remove current items
		Compare._$basket.removeClass('comparing').find('.item').remove();
		Compare._active = 0;
		Compare._status();

		Compare._$hdr.find('.compare').unbind();
		Compare._$hdr.find('.apply-button a').unbind();

		Compare._$basket.find('.button span').text('Compare selected');
		$('#left-panel').find('.content, .edit-selection .button').fadeIn();
	},

	toggle: function(){
		$('.pagination').toggle();

		<%-- stop comparing and return to normal --%>
		if( Compare._$basket.hasClass('comparing')   ){
			Compare._$hdr.find('.pagination, .compare-button').fadeIn();
			$('#left-panel').find('.content, .edit-selection .button').fadeIn();
			Compare._$hdr.find('.result-row').animate({ width: 'show' });
			Compare._$table.find('.result-row').animate({ width: 'show' });

			$('body').removeClass('comparing');
			Compare._$basket.removeClass('comparing').find('.button span').text('Compare selected');

			$('#HLT_InPageRight').css('display', nextShadowState);
			return;
		};

		<%-- start the comparing mode --%>
		if( !Compare._$basket.hasClass('comparing') &&  Compare._active >= 2 ){
			Compare._$hdr.find('.pagination, .compare-button').fadeOut();
			$('#left-panel').find('.content, .edit-selection .button').fadeOut();
			<%-- selectively hide --%>
			var compareIds = [];
			Compare._$hdr.find('.result-row').each( function(){
				var id = $(this).attr('data-id');
				if( Compare._$basket.find('.item[data-id="'+ id +'"]').length == 0   ){
					Compare._$hdr.find('.result-row[data-id="'+ id +'"]').animate({ width: 'hide' });
					Compare._$table.find('.result-row[data-id="'+ id +'"]').animate({ width: 'hide' });
				}
				else
				{
					compareIds.push(id);
				};
			});

			Results.paginate(1); //reset the sliders to the first slide

			$('body').addClass('comparing');
			Compare._$basket.addClass('comparing').find('.button span').text('View all products');

			Track.onCompareProducts( compareIds );

			$("#HLT_InPageRight, #HLT_InPageLeft").hide();

			return;
		};
	},

	<%-- status for the basket area - show message and button --%>
	_status: function(){
		switch(true) {
			case ( Compare._active >= 2 ):
				Compare._$basket.find('.status').fadeOut();
				Compare._$basket.find('.button').slideDown().css('display','block');
				break;
			case  (Compare._active === 1):
				Compare._$basket.find('.button').slideUp();
				Compare._$basket.find('.status').text('Please pick at least one more product to compare').fadeIn();
				break;
			case (Compare._active === 0):
				Compare._$basket.find('.button').slideUp();
				Compare._$basket.find('.status').text('Please pick at least two products to compare').fadeIn();
				break;
		};
	}
};



var Results = new Object();
Results = {
	_currentPrices : new Object(),
	_priceCount : 0,
	_initialSort : true,
	_loadingLeadNo : false,
	_revising : false,
	_sortDir : 'asc',
	_isShown : false,
	_paginationStep : 702,
	_paginationOuter : 250,
	_sortStep: 234,
	_selectedProduct : false,
	_eventMode : false,
	_incAltPrice : false,
	_editBenefits : false,
	_pricesHaveChanged : false,
	_priceShown : false,

	<%--
		Results page - gets its results from Health.js
		1.
	--%>

	// INITIALISATION
	init : function(){
		if( Results._editBenefits === true ) {
			ResultsBenefitsManager.incrementTransactionId = false;
			Results.show( true );
		} else {
			ResultsBenefitsManager.incrementTransactionId = true;
			Results._editBenefits = false;
			Health.fetchPrices();
		}
	},

	showMoreInfo: function( that ) {
		if (typeof Kampyle != "undefined") {
			Kampyle.setFormId("85272");
		}

		var id = $(that).closest('.result-row').attr('data-id');
		var _obj = Results.getResult(id);
		if (typeof _obj == 'object') {
			healthPolicySnapshot.J_product = _obj;
			healthPolicySnapshot.$J_productHtml = $(that).closest('.result-row');
			healthPolicySnapshot.create();
			$('#more_snapshotDialog').dialog({ 'dialogTab':0 }).dialog('open');
			Track.onMoreInfoClick( id );
		}
		else {
			alert('Oops! More details can not be shown.');
		}
	},

	applyNow: function($_obj, trackType) {
		if (typeof Kampyle != "undefined") {
			Kampyle.setFormId("85272");
		}

		<%-- trackType is used by superT.trackHandoverType --%>
		trackType = trackType || 'Online_R';

		<%-- check mandatory dialog have been ticked  --%>
		var $_exacts = $('#resultsPage').find('.simples-dialogue.exact');
		if( $_exacts.length != $_exacts.find('input:checked').length ){
			generic_dialog.display('<p>Please complete the mandatory dialogue prompts before applying.</p>', 'Validation Error');
			return false;
		};

		<%--  Check user still owner and touch the quote before proceeding --%>
		Write.touchQuote("A", function() {

			var _id = $_obj.attr('data-id');

			var uncheck_health_delaration = typeof(Results._selectedProduct) == 'object' && _id != Results._selectedProduct.productId;

			Results.setProduct(_id);

			healthPolicySnapshot.J_product = false;
			healthPolicySnapshot.$J_productHtml = $_obj;
			healthPolicySnapshot.create();

			<%-- 'super' fund customisation --%>
			healthFunds.load( Results._selectedProduct.info.provider, function() {
			var $_main = $('#mainform');
			$_main.find('.health_application_details_provider').val( Results._selectedProduct.info.provider);
			$_main.find('.health_application_details_productId').val( Results._selectedProduct.info.productId);
			$_main.find('.health_application_details_productNumber').val( Results._selectedProduct.info.productCode);
			$_main.find('.health_application_details_productTitle').val( Results._selectedProduct.info.productTitle);

			<%--  Unset the Health Declaration checkbox --%>
			if( uncheck_health_delaration ) {
					$('#health_declaration:checked').each(function(){
					this.checked = false;
				});
			}

			Results.renderApplication();

			Results.hidePage();
			$('#next-step').trigger('click');

			Track.onApplyClick( Results._selectedProduct, trackType );
		});
		});
	},

	renderApplication: function(){
		<%-- Trigger other Application functions --%>
		if(typeof(paymentSelectsHandler) != 'undefined' && Health._mode != HealthMode.CONFIRMATION) {
		paymentSelectsHandler.updateSelect(); //update the payment frequency info
		}
		healthPolicyDetails.create(); //render the results for the product summary
		healthPolicySnapshot.create(); //create the more information and confirmation objects
	},

	setProduct: function( _id ){
		var _success = Results.getResult(_id);
		if( typeof _success == 'object' ) {
			Results.setSelectedProduct( _success );
			return true;
		};
		return false;
	},

	setSelectedProduct : function( product_obj )
	{
		Results._selectedProduct = product_obj;
	},

	getSelectedProduct : function()
	{
		return Results._selectedProduct;
	},

	getSelectedProductByID : function( product_id )
	{
		return Results.getResult( product_id );
	},

	getSelectedPremium: function(){
		var _frequency = Results.getFrequency();

		switch(_frequency)
		{
			case "W":
				var label = 'weekly';
				var frequency = 'Per Week';
				break;
			case "F":
				var label = 'fortnightly';
				var frequency = 'Per Fortnight';
				break;
			case "M":
				var label = 'monthly';
				var frequency = 'Per Month';
				break;
			case "Q":
				var label = 'quarterly';
				var frequency = 'Per Quarter';
				break;
			case "H":
				var label = 'halfyearly';
				var frequency = 'Per Half-Year';
				break;
			case "A":
				var label = 'annually';
				var frequency = 'Per Year';
				break;
			default:
				return false; //REFINE: something broke, handle better
				break;
		};
		if (!Results._selectedProduct) {
			return {'value':'', 'text':'', 'label':frequency, 'period':label };
		}
		var _star = Results._selectedProduct.premium.discounted=='Y'?'*':'';
		return {
			'value':Results._selectedProduct.premium[label].value,
			'text':_star+Results._selectedProduct.premium[label].text,
			'pricing': _star+Results._selectedProduct.premium[label].pricing,
			'lhcfreevalue': Results._selectedProduct.premium[label].lhcfreevalue,
			'lhcfreetext': _star+Results._selectedProduct.premium[label].lhcfreetext,
			'lhcfreepricing': _star+Results._selectedProduct.premium[label].lhcfreepricing,
			'label': frequency,
			'period': label
		};
	},

	getSelectedAltPremium: function(){
		var _frequency = Results.getFrequency();

		var output = {
				from: "",
				text: "",
				value: 0
		}

		output.from = altPremium.from;

		switch(_frequency)
		{
			case "W":
				output = $.extend(output, Results._selectedProduct.altPremium.weekly);
				break;
			case "F":
				output = $.extend(output, Results._selectedProduct.altPremium.fortnightly);
				break;
			case "M":
				output = $.extend(output, Results._selectedProduct.altPremium.monthly);
				break;
			case "Q":
				output = $.extend(output, Results._selectedProduct.altPremium.quarterly);
				break;
			case "H":
				output = $.extend(output, Results._selectedProduct.altPremium.halfyearly);
				break;
			case "A":
				output = $.extend(output, Results._selectedProduct.altPremium.annually);
				break;
			default:
				// Simply return the default - MONTHLY
				output = $.extend(output, Results._selectedProduct.altPremium.monthly);
				break;
		};

		return output;
	},

	getFrequency: function() {
		var _frequency = paymentSelectsHandler.getFrequency();

		<%-- Use the frequency filter --%>
		if (Health._mode != HealthMode.CONFIRMATION && (_frequency == '' || QuoteEngine.getCurrentSlide() <= 2)) {
			_frequency = $('#show-price').find(':checked').val();
		};

		if (Health._mode === HealthMode.PENDING && Results._selectedProduct && Results._selectedProduct.frequency) {
			_frequency = Results._selectedProduct.frequency;
		}

		return _frequency;
	},

	getFrequencyNumber: function() {
		var _frequency = Results.getFrequency();

			switch(_frequency)
			{
			case "W":
				var frequencyNumber = 52;
				break;
			case "F":
				var frequencyNumber = 26;
				break;
			case "M":
				var frequencyNumber = 12;
				break;
			case "Q":
				var frequencyNumber = 4;
				break;
			case "H":
				var frequencyNumber = 2;
				break;
			case "A":
				var frequencyNumber = 1;
				break;
			default:
				return false; //REFINE: something broke, handle better
				break;
			};

		return frequencyNumber;
	},

	getFrequencyToString : function( freq ) {
		switch(freq.toUpperCase()) {
			case 'A': return 'annually';
			case 'F' : return 'fortnightly';
			case 'H' : return 'halfyearly';
			case 'Q' : return 'quarterly';
			case 'W' : return 'weekly';
			case 'M' : default : return 'monthly';
		}
	},

	rates: function(jsonObject) {
		Results._rates = jsonObject;
		<c:if test="${not empty callCentre}">
			var loading = Results.getLoading();
			$('.health_cover_details_rebate .fieldrow_legend').html('Overall LHC ' + loading + '%');
			if(healthChoices._cover == 'F' || healthChoices._cover == 'C'){
				$('#health_healthCover_primaryCover .fieldrow_legend').html('Individual LHC ' + jsonObject.primaryLoading + '%, overall  LHC ' + loading + '%');
				$('#health_healthCover_partnerCover .fieldrow_legend').html('Individual LHC ' + jsonObject.partnerLoading + '%, overall  LHC ' + loading + '%');
			} else {
				$('#health_healthCover_primaryCover .fieldrow_legend').html('Overall  LHC ' + loading + '%');
			}
		</c:if>
	},

	getRebate: function(){
		return this._rates.rebate;
	},

	getLoading: function(){
		return this._rates.loading;
	},

	cleanUnavailableDetails: function(jsonObject) {

		if(typeof jsonObject == 'undefined'){
			return;
		};

		for(var i = 0; i < jsonObject.length; i++) {
			var extras = jsonObject[i].extras;
			var benefits = jsonObject[i].hospital.benefits;

			for(var j in extras) {
				var e = extras[j];

				if( e.hasOwnProperty("covered") ) {
					if( e.covered.toLowerCase() == "n" ) {
						if( e.hasOwnProperty("waitingPeriod") ) {
							e.waitingPeriod = "-";
						}
						if( e.hasOwnProperty("benefitLimits") ) {
							for(var bl in e.benefitLimits) {
								e.benefitLimits[bl] = "-";
							}
						}
						if( e.hasOwnProperty("groupLimits") ) {
							for(var gl in e.groupLimits) {
								e.groupLimits[gl] = "-";
							}
						}
						if( e.hasOwnProperty("loyaltyBonus") ) {
							for(var lb in e.loyaltyBonus) {
								e.loyaltyBonus[lb] = "-";
							}
						}
						if( e.hasOwnProperty("hasSpecialFeatures") ) {
							e.hasSpecialFeatures = "-";
						}
						if( e.hasOwnProperty("listBenefitExample") ) {
							e.listBenefitExample = "-";
						}
					}
				}
			}

			for(var k in benefits) {
				var b = benefits[k];

				if( b.hasOwnProperty() ) {
					if( b.covered.toLowerCase() == "n" ) {
						if( b.hasOwnProperty("WaitingPeriod") ) {
							b.WaitingPeriod = "-";
						}
					}
				}
			}
		}
	},

	prices: function(jsonObject) {
		Results.cleanUnavailableDetails(jsonObject);

		if( altPremium.exists() ) {
			$("#resultsPage").addClass("hasAltPremium");
		} else {
			$("#resultsPage").removeClass("hasAltPremium");
		}

		Results._updatePrices(jsonObject);
	},

	<%-- //FIX: make the event handling a bit smarter and throw the user back a page if required. --%>
	errorHandler: function(type){
		FatalErrorDialog.exec({
			message:		'Error: we could not find any results for this search',
			page:			"health:results.tag",
			description:	"Results.errorHandler(). Error received: " + type,
			data:			null
		});
		Results.startOver();
	},

	eventMode: function() //used with superTag
	{
		switch(Results._eventMode)
		{
			case "Load":
			case "Refresh":
				Results._eventMode = "Refresh";
				break;
			default:
				Results._eventMode = "Load";
				break;
		}

		return Results._eventMode;
	},

	<%-- driven by the main rebate/prices function in the vertical JS --%>
	show: function( benefits_only ) {
		<%-- Flag to render edit benefits panel rather than results content --%>
		var benefits_only = benefits_only || false;

		if (typeof Kampyle != "undefined") {
			Kampyle.setFormId("85252");
		}

		<%-- Hide normal results content and just show the expanded edit benefits panel --%>
		if( benefits_only ) {
			$('html,body').scrollTop(0);
			$('#page').fadeOut(300);
			$("#header, #navContainer").addClass("resultsPage");

			$('#resultsPage').addClass('benefitsOnly');
			$('#results-summary').removeAttr("style");
			$('#resultsPage').fadeIn(300, function(){
				$.address.parameter("stage", "results", false );
				$('#ChooseBenefits').trigger('click');
<c:choose>
	<c:when test="${callCentre}">
				$('#resultsPage').css({height:1250});
	</c:when>
	<c:otherwise>
				$('#resultsPage').css({height:607});
	</c:otherwise>
</c:choose>
				$('#health_benefitsCloseBtn').hide();
			});
		<%-- Otherwise just render results normally --%>
		} else {
		Results._revising = true;

			$('#resultsPage').removeClass('benefitsOnly');

		if(!Results._isShown){
			Results.showPage();
		} else {
			<%-- The page has already been loaded, so perform some function resets --%>
			Results._initTableControls();
		};
		}
		if(Results._pricesHaveChanged) {
			Loading.hide(function(){
				PricesChangedNote.show();
			});
		} else {
		Loading.hide();
		}
	},

	// SHOW/ANIMATE THE RESULTS
	showPage : function(){
		$('html,body').scrollTop(0);
		$('#page').fadeOut(300);
		$("#header, #navContainer").addClass("resultsPage");

		$('#resultsPage').fadeIn(300, function(){
			$.address.parameter("stage", "results", false );
			<%-- Update scroll trigger point --%>
			FixedResults.updateTop();
		});

		Results.resizePage();

		contactPanelHandler.reinit();

		this._isShown=true;
		FixedResults.init();

		<%-- When forward/back browser buttons clicked - page needs to be reset --%>
		$.address.externalChange(function(){
			Results.hidePage();
		});
	},

	//RESET/REVERSE: showing the results page
	hidePage: function(){
		$('html,body').scrollTop(0);
		$('#page').fadeIn(300);
		$("#header, #navContainer").removeClass("resultsPage");

		$('#resultsPage').fadeOut(300, function(){
			$.address.parameter("stage", "results", true );
		});

		$('#health_benefitsCloseBtn').trigger("click");

		this._isShown=false;
		FixedResults.destroy();

	},

	<%-- The user has come back to the results back by 'hitting reverse' --%>
	revisit: function(){
		Results._highlightProduct();
		Results._matchPaymentFrequency();
		Results.softReset();
		Results.showPage();
	},

	<%-- RESIZEs the whole page to contain the positioned results --%>
	resizePage: function(){
		var benefits_offset = 0;
		if( $('#results-fixed').hasClass('extended') ) {
			benefits_offset = 443; <%-- additional height of the extended benefits element --%>
		}
		var _height = benefits_offset + $('#left-panel').outerHeight() + ($('#left-panel').offset().top - $('#resultsPage').offset().top) +'px';
		$('#resultsPage, #results-container').css('height', _height);
		$("#HLT_InPageRight").css('height',_height);
		$("#HLT_InPageLeft").css('height',_height);

		<%-- Update scroll trigger point --%>
		FixedResults.updateTop();
	},

	// GET RESULT
	getResult : function(id){
		var i =0;
		while (i < this._currentPrices.length) {
			if (this._currentPrices[i].productId == id ){
				return this._currentPrices[i];
			}
			i++;
		}
		return false;
	},

	// GET RESULT POSITION
	getResultPosition : function(id){
		var i =0;
		while (i < this._currentPrices.length) {
			if (this._currentPrices[i].productId == id ){
				return i;
			}
			i++;
		}
		return -1;
	},

	// GET TOP POSITION
	getTopPosition : function(){
		return this._currentPrices[0].productId;
	},

	// GET THE REFERENCE NUMBER
	getLeadNo : function(id, destDiv){
		var r=this.getResult(id);
		if (r){
			if (r.leadNo != ""){
				return r.leadNo;
			} else if (r.refnoUrl != ""){
				this._loadLeadNo(r, destDiv);
			}
		}
		return "";
	},
	_updateSummaryText : function(){
		$("#results-summary").hide();

		var txt = "We have identified "+ Results._priceCount +" results based on a "+ healthChoices.returnCover() +" in " + healthChoices.returnState(true) +" looking for "+ healthChoices.returnSituation() + ". <span class='criteria'>Based on the information you have supplied, we have calculated your LHC percentage as " + Results.getLoading() + "%</span>";
		<%-- "and a rebate of " + Results._rates.rebate +"%." --%>

		$("#results-summary h2").html(txt);
		$("#results-summary").fadeIn();
	},

	<%--  SORT PRICES --%>
	<%--  Sort prices can be initiated via a button, or price loading. --%>
	_getSortType : function( verbose ){
		verbose = verbose || false;
		if( $('#rank-results-by :checked').val() == 'L' ){
			return verbose === true ? 'price' : 'L';
		} else {
			return verbose === true ? 'benefits' : 'B';
		};
	},
	sortReset: function(){
		this._sortPrices.active = false;
	},

	<%-- Calculate sort order then order the results columns --%>
	sort: function(){
		if(this._sortPrices.active == true){
			return; //already active
		};

		this._sortPrices();

		if( Results._priceShown === true ) {
		Results.writeRanking('health', Results._currentPrices, Results._getSortType(true), Results._sortDir, Results.getFrequency());
		}

		<%-- Animate: move the object by it's new index vs the dom index --%>
		var newIndex = 0;
		$(Results.sortArray).each( function(){

			id = this.productId;
			$_obj = $('#resultHdr_' + id);

			<%-- Don't bother processing if it's hidden (filtered) --%>
			if (!$_obj.hasClass('filtered')) {
				<%-- In the DOM, are there any filtered results preceeding this result? --%>
				var filteredBefore = $_obj.prevUntil('', '.filtered').length;

				<%-- The actual column position that this result sits in --%>
				var column = $_obj.index() - filteredBefore;

				<%-- Did the result get moved during sorting? --%>
				if (newIndex != this.currentPos || filteredBefore != this.filteredBefore) {
					var destinationLeft = (newIndex - column);

					<%-- If the results were filtered, and the result has already moved into position because of DOM flow --%>
					if (destinationLeft == 0 || filteredBefore != this.filteredBefore) {
						var dl = this.currentPos - column;
						$_obj.add( $('#resultRow_' + id)   ).css({
							left: dl * Results._sortStep
						});
					}

					<%-- Animate to intended position --%>
					$_obj.add( $('#resultRow_' + id)   ).animate({
						left: destinationLeft * Results._sortStep
			});

					this.currentPos = newIndex;
					this.filteredBefore = filteredBefore;
				}
			newIndex++;
			}
		});

		Results._paginationCurrent();

		Track.onResultsShown(Results.eventMode());
	},

	<%-- Sort the prices by rank or price --%>
	_sortPrices : function(){
		<%-- Starting Variables --%>
		var _priceCat = Results._getFilterName( Results._getFilterType() );
		var by = this._getSortType();
		<%-- Sorting --%>
		this._sortPrices.active = true; //highlander rule
		switch( by ) {
			case 'L':
				Results.sortArray.sort(function(a,b) {
					return (a.premium[_priceCat].lhcfreevalue - b.premium[_priceCat].lhcfreevalue);
				});
				break;
			case 'B':
				Results.sortArray.sort(function(a,b) {
					if( (a.rank < b.rank) || ( (a.rank == b.rank) && (a.premium[_priceCat].lhcfreevalue > b.premium[_priceCat].lhcfreevalue) ) ){
						return 1;
					} else {
						return -1;
					};
				});
				break;
		};
		this._sortPrices.active = false;
	},

	_getFilterType : function(){
		switch( $('#show-price :checked').val() ) {
			case 'F':
				return 'F';
			case 'A':
				return 'A';
			default:
				return 'M';
		};
	},

	_getFilterName: function(){
		switch( Results._getFilterType() ){
			case 'F':
				return 'fortnightly';
				break;
			case 'A':
				return 'annually';
				break;
			default:
				return 'monthly';
				break;
		};
	},

	<%-- FILTER results - turn on and off products that do-not support the filter --%>
	filter: function( increment_tran_id ){

		increment_tran_id = increment_tran_id || false;

		switch( Results._getFilterType() ) {
			case 'F':
				var _type = Results._getFilterName('F');
				var _label = 'Per Fortnight';
				break;
			case 'A':
				var _type = Results._getFilterName('A');
				var _label = 'Per Year';
				break;
			default:
				var _type = Results._getFilterName('M');
				var _label = 'Per Month';
				break;
		};

		var id = '';
		$(Results._currentPrices).each( function(){
			id = this.productId;
			$_obj = $("#resultHdr_" + id);

			if(this.premium[_type].lhcfreevalue == ''){
				$_obj.add("#resultRow_" + id).addClass('filtered');
			} else {
				$_obj.add("#resultRow_" + id).removeClass('filtered');
				$_obj.find('.premium .frequency').text(_label);
				$_obj.find('.premium strong').text(this.premium[_type].lhcfreetext);
				$_obj.find('.premium').attr("data-text", this.premium[_type].text);
				$_obj.find('.premium').attr("data-lhcfreetext", this.premium[_type].lhcfreetext);
				Results._refreshSimplesTooltipContent($_obj.find('.premium'));
				$_obj.find('.pricing').text(this.premium[_type].lhcfreepricing);
			};
		});

		<%-- Resort the Price Objects! --%>
		Results.sortReset();
		Results.sort();

		<%-- Check if there are any items to display --%>
		if( !Results.visiblePriceCount()  ){
			$('#headerError').html('There are no products available based on the filter you have chosen.<br /><br />Please try again or contact us for assistance.').fadeIn();
		} else {
			$('#headerError').hide();
		};
	},

	<%-- Sorts rows of selected benefits under the "Selected benefits" headings --%>
	_sortSelected: function($_obj){
		$_obj.find('div.expandable').each(function(){
			if( healthChoices.hasBenefit( $(this).attr("data-id") ) ) {
				$(this).appendTo( $_obj.find('.selected')  );
			};
		});
	},

	<%-- Apply zebra striping to rows --%>
	_sortStriping: function($_obj, count){
		if( count === undefined){
			count = 1;
		};
		$_obj.find("div.expandable,div.non-expandable, h5").each(function(){
			if( count % 2 === 0 ) {
				$(this).addClass("even");
			};
			count++;
		});
		return count;
	},

	<%-- take the delegated expand events and open/close them --%>
	expand: function(_id){
		var _group = $("#results-container").find('.expandable[data-id="'+ _id +'"]');
		if( _group.hasClass('open') ){
			_group.removeClass('open');
		} else {
			_group.addClass('open');
		};

		Results.resizePage();
	},
	<%-- add hover ability across all of the row --%>
	hoverrow: function(_id){
		var _group = $("#results-container").find('.expandable[data-id="'+ _id +'"]');
		<%-- Hover will not work here. Basically because the validation consumes the first rollover. --%>
			$(_group).mouseover(function() {
				$(_group).addClass("hoverrow");
			}).mouseout(function(){
				$(_group).removeClass("hoverrow");
			});

	},

	_updatePrices : function(prices){
		prices=[].concat(prices);
		Results._currentPrices = prices;
		Results._priceShown = false;

		<%-- If there's a problem with the prices - bail --%>
		if(typeof Results._currentPrices[0] == "undefined") {
			Results._priceCount = 0;
			Results.searchNone();
			return false;
		};

		<%-- See if a new product needs to be injected --%>
		Results._injectProduct();

		Results.sortArray = new Array;

		<%-- Add only the Template components that are required --%>
		switch(Results._currentPrices[0].info.ProductType) {
			case 'GeneralHealth':
				var _hospital = false;
				var _extras = true;
				break;
			case 'Hospital':
				var _hospital = true;
				var _extras = false;
				  break;
			default:
				var _hospital = true;
				var _extras = true;
				  break;
		};

		<%-- Create Cleanskins Dom Elements --%>

		var helpScriptTmpl = $("#results-help").html();

		<%-- Hospital Only --%>
		if(_hospital){
			var $_T_hospitalInclusionsLabels = $(document.createElement('div')).html( $("#hospital-inclusions-labels-template").html() );
			var $_T_hospitalInclusions = $(document.createElement('div')).html( $("#hospital-inclusions-template").html() );

			<%-- ADD: zebra classes to default rows --%>
			var _count = Results._sortStriping($_T_hospitalInclusionsLabels);
			Results._sortStriping($_T_hospitalInclusions);

			var $_T_hospitalBenefitsLabels = $(document.createElement('div')).html( $("#hospital-benefits-labels-template").html() );
			var $_T_hospitalBenefits = $(document.createElement('div')).html( $("#hospital-benefits-template").html() );

			<%-- Move selected benefits --%>
			Results._sortSelected($_T_hospitalBenefitsLabels);
			Results._sortSelected($_T_hospitalBenefits);
			<%-- Zebra Striping --%>
			Results._sortStriping($_T_hospitalBenefitsLabels, _count);
			Results._sortStriping($_T_hospitalBenefits, _count);

			<%-- Merge the benefits/inclusions labels --%>
			$_T_hospitalInclusionsLabels.html( $_T_hospitalInclusionsLabels.html() + $_T_hospitalBenefitsLabels.html() );

			<%-- Insert new footers --%>
			//$_T_hospitalInclusionsLabels.append( $("#footer-template").html() );
			//$_T_hospitalInclusions.append( $("#footer-template").html() );

			<%-- Return labels to static side --%>
			$("#matchCategoryHospital .row.mid.md").eq(0).empty().append($_T_hospitalInclusionsLabels);
			$('#matchCategoryHospital').show();
		} else {
			//kill the HTML that's not required
			$('#matchCategoryHospital').hide();
		};

		<%-- Extras Only --%>
		if(_extras){
			$('#matchCategoryExtras').show();
			var $_T_extrasLabels = $(document.createElement('div')).html( $("#extras-labels-template").html() );
			var $_T_extras = $(document.createElement('div')).html( $("#extras-template").html() );

			<%-- Move selected extras --%>
			Results._sortSelected($_T_extrasLabels);
			Results._sortSelected($_T_extras);

			<%-- Zebra Striping --%>
			Results._sortStriping($_T_extrasLabels);
			Results._sortStriping($_T_extras);

			<%-- Return labels to static side --%>
			$("#matchCategoryExtras .row.mid.dk").eq(0).empty().append($_T_extrasLabels);
			$('#matchCategoryExtras').show();
		} else {
			//kill the HTML that's not required
			$('#matchCategoryExtras').hide();
		};

		<%-- Begin the rendering --%>

		$("#results-table").hide();
		$("#results-header .current-results, #results-table .current-results").html("");

		Results._priceCount = 0;

		if (prices != undefined) {
			$.each(prices, function() {

				if (this.available == "Y") {
					<%-- FIX --%>
					<%-- Because currently rank is a sum of the benefits selected, it will always be equal value across the products. --%>
					<%-- For now, force the rank to be the order that the results were returned it. Algorithm 2 needs this. --%>
					this.info.rank = 20 - Results._priceCount;

					<%-- Check if restricted fund and pass class so that renders properly --%>
					this.info['restrictedFundClass'] = '';
					if( this.info.restrictedFund == 'Y' ) {
						this.info.restrictedFundClass = 'restricted';
					}

					<%-- Push JSON data into areas where they will be quickly parsed by the template --%>
					Results.jsonExpand(this);
					Results.sortArray.push( this.info );
					Results.sortArray[Results.sortArray.length-1].currentPos = Results._priceCount;
					Results.sortArray[Results.sortArray.length-1].filteredBefore = 0;

					var _headerHTML = $(parseTemplate( $("#result-header-template").html() , this.info));
					var _tableHTML = $(parseTemplate( $("#result-table-template").html(), this.info));
					var _detailsHTML = $(parseTemplate ( $("#details-template").html(), this.info));
					var _ambulanceHTML = $(parseTemplate( $("#ambulance-template").html(), this.ambulance));

					<%-- Match the main content data into the templates --%>
					$(_tableHTML).find('.matchDataDetails').append(_detailsHTML);
					$(_tableHTML).find('.matchDataAmbulance').append(_ambulanceHTML);


					if(_hospital){
						var _hospitalHTML = $( parseTemplate($_T_hospitalInclusions.html(),this.hospital.inclusions) + parseTemplate($_T_hospitalBenefits.html(),this.hospital.benefits)  );
						$(_tableHTML).find('.matchDataHospital').append(_hospitalHTML);
					} else {
						$(_tableHTML).find('.matchDataHospital').remove();
					};

					if(_extras){
						var _extrasHTML = $(parseTemplate($_T_extras.html(),this.extras));
						$(_tableHTML).find('.matchDataExtras').append(_extrasHTML);
					} else {
						$(_tableHTML).find('.matchDataExtras').remove();
					};

					Results._priceCount++;

					// Append to the header & table
					$("#results-header>.current-results").append(_headerHTML);
					$("#results-table .current-results").append(_tableHTML);

					Results._priceShown=true;


				} else {
					<%-- RESOLVE: there is no unavailable item alert("HTML Template Error"); --%>
				};

			});
		};

		$('#left-panel').find('.expandable, .non-expandable').removeClass('open');

		<%-- Are there any products to show or not... --%>
		if (Results._priceShown){
			$("#results-table").show();
			this._initTableControls();
			this._initSimplesTooltips();
			$('#headerError').hide();
			Results.filter(); <%-- Filter contains the sort function --%>
			Results._highlightProduct();
		} else {
			Results.searchNone();
		};
		Results.resizePage();
		//Loading.hide(); <%-- Double Check that the loading is off --%>

		<%-- Activate help text for any restricted icons --%>
		$('.restricted_help').each(function() {
			var that = this;
			$(this).parent().click(function() {
				var id = 518;
				<%-- Crazy positioning to keep the tooltip on the results header even if scrolling between fixed and non-fixed states --%>
				$(that).css({top: 0});
				if ($('body').hasClass('FixedResults')) {
					var _top = $(that).offset().top - FixedResults.scrollTop() + FixedResults._top + 4;
					<%-- console.log('_top:' + _top + ' = that.top:' + $(that).offset().top + ' - scrollY:' + FixedResults.scrollTop() + ' + ' + FixedResults._top + ' + 4'); --%>
					$(that).offset({top: _top});
				}
				Help.update(id,$(that));
			});
		});
	},

	writeRanking : function(rootPath, sortedPrices, sortBy, sortDir, premiumFrequency) {

		var data = {
				rootPath : 		rootPath,
				rankBy : 		sortBy + "-" + sortDir,
				rank_count :	sortedPrices.length
		};

		for (var i = 0 ; i < sortedPrices.length; i++) {
			var freq = Results.getFrequencyToString(premiumFrequency);
			var price = sortedPrices[i];
			var prodId = price.productId.replace('PHIO-HEALTH-', '');
			data["rank_productId" + i]		= prodId;
			data["rank_price_actual" + i]	= price.premium[freq].value.toFixed(2);
			data["rank_price_shown" + i]	= price.premium[freq].lhcfreevalue.toFixed(2);
			data["rank_frequency" + i]		= freq;
			data["rank_lhc" + i]			= price.premium[freq].lhc;
			data["rank_rebate" + i]			= price.premium[freq].rebate;
			data["rank_discounted" + i]		= price.premium[freq].discounted;
		}

		$.ajax({
			url:		"ajax/write/quote_ranking.jsp",
			data:		data,
			type: 		'POST',
			async: 		true,
			timeout:	30000,
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			}
		});
	},

	searchNone: function(){
		$('#headerError').html('Sorry, your search returned no results.<br /><br />Please try again or contact us for assistance.<br/><br/>Tip: Check that your result filters are not too restrictive.').fadeIn();
		Results._initTableControls();
	},

	<%-- Merge different JSON values into the product to quickly expand it  --%>
	jsonExpand: function(J_obj){
		J_obj.info.productId = J_obj.productId;
		J_obj.info.premium = J_obj.premium;
		if(altPremium.exists() && typeof J_obj.altPremium == "object") {
			J_obj.info.altPremiumContent  = altPremium.getHTML(J_obj.altPremium.monthly);
		} else {
			J_obj.info.altPremiumContent  = "";
		}
		J_obj.info.promoText = J_obj.promo.promoText;
		J_obj.info.discountText = J_obj.promo.discountText;

		if(typeof J_obj.custom == 'undefined'){
			J_obj.custom = {};
		};
		if(typeof J_obj.custom.info == 'undefined'){
			J_obj.custom.info = {};
		};
		if(typeof J_obj.custom.info.exclusions == 'undefined'){
			J_obj.custom.info.exclusions = {};
		};
		if (typeof J_obj.custom.info.exclusions.cover == 'undefined'){
			J_obj.custom.info.exclusions.cover = "";
		};

			<%-- Hospital --%>
			if (J_obj.info.ProductType != 'GeneralHealth'){
				J_obj.hospital.inclusions.hospitalPDF = J_obj.promo.hospitalPDF;
				J_obj.hospital.benefits.exclusions = { 'cover':J_obj.custom.info.exclusions.cover };
			};
			<%-- Extras --%>
			if(J_obj.info.ProductType != 'Hospital'){
				J_obj.extras.extrasPDF = J_obj.promo.extrasPDF;
				J_obj.extras.exclusions = { 'cover':J_obj.custom.info.exclusions.cover};
				if( typeof J_obj.extras.DentalGeneral.benefits.DentalGeneral322Extraction == 'undefined' || J_obj.extras.DentalGeneral.benefits.DentalGeneral322Extraction == '' ){
					J_obj.extras.DentalGeneral.benefits.DentalGeneral322Extraction = '-';
				};
			};
	},

	<%-- Check to see if there's a selected product and handle --%>
	_injectProduct: function(){
		var _selectedID = $('#mainform').find('.health_application_details_productId').val();
		if( _selectedID == '' ) {
			return false;
		};

		<%-- Iterate and see if exists --%>
		var _success = false;
		$(Results._currentPrices).each( function(){
			if( this.productId == _selectedID ){
				_success = true;
				return true;
			};
		});

		var _push = false;
		<%-- Need to re-search the product as it may no longer be applicable --%>
		if( _success == true ){
			return true; <%-- Already in --%>
		} else {
			var _newProduct = Health.fetchPrice(true);
			if( !_newProduct ){
				return false; //FIX: //REFINE: like to add in a message here
			} else {
				Results._currentPrices.push( Results._selectedProduct ); <%-- Added in the new product --%>
			};
		};
	},

	<%-- Clears out the selected products and highlights a lucky one --%>
	_highlightProduct: function(){
		$('#resultsPage').find('.result-row').removeClass('selected');
		$('#resultsPage').find('.result-row[data-id="'+ $('#mainform').find('.health_application_details_productId').val() +'"]').addClass('selected');

		<%--
		var _selectedID = $('#mainform').find('.health_application_details_productId').val();

		$('#resultsPage').find('.result-row').each( function(){
			if( $(this).attr('data-id') == _selectedID){
				$(this).addClass('selected');
			} else {
				$(this).removeClass('selected');
			};
		});

		--%>

	},

	_matchPaymentFrequency: function(){
		<%-- Update frequency according to the one selected on payment page if it's set --%>
		var freq = paymentSelectsHandler.getFrequency();
		if( $.inArray(freq, ['F','A','M']) != -1 ){
			$('#show-price input[value='+freq+']').prop("checked", "checked").trigger("change");
		}
	},

	_initTableControls : function(){
		Results._updateSummaryText();
		Compare.bind();
		
		$('#HLT_InPageLeft').hide();
		$('#HLT_InPageRight').hide();
		Results._pagination();
	},

	_initSimplesTooltips: function(){
		<c:if test="${callCentre}">
		$('.premium').each(function(){

			$(this).qtip({
				content: {
					text: Results._getSimplesTooltipContent(this)
				},
				position: {
					my: 'bottom center',
					at: 'top center'
				},
				style: {
					classes: 'simplesTooltips',
					widget: true
				}
			});

		});
		</c:if>
	},

	_refreshSimplesTooltipContent: function(element){
		$(element).each(function(){
			if ( $(this).attr('data-hasqtip') == "true"){
				$(this).qtip('option', 'content.text', Results._getSimplesTooltipContent(this));
			}
		});
	},

	_getSimplesTooltipContent: function(element){
		return "Premium: " + $(element).attr("data-text") + "<br/>" + "Premium LHC Excluded: "+ $(element).attr("data-lhcfreetext");
	},

	visiblePriceCount: function(){
		if( $('#results-header').is(':visible') ){
			return $('#results-header .current-results > div:visible').length;
		} else {
			return Results._priceCount;
		};
	},

	<%-- Makes pagination only based on the visible products (for comparing and filtering) --%>
	_paginationCurrent: function(){
		Results._paginationStages = Math.ceil( Results.visiblePriceCount() / (Results._paginationStep / Results._paginationOuter) );

		<%-- If filter has removed a page, scroll back to new last page --%>
		if (Results._paginationStage > Results._paginationStages) {
			Results._paginationAnimate(Results._paginationStages);
		}
		<%-- otherwise use _paginationAnimate to turn on/off the correct pagination states --%>
		else {
			Results._paginationAnimate(Results._paginationStage);
		}

		if (Results._paginationStages <= 1) {
			$('#results-bar').find('.pagination .page').hide();
			$("#HLT_InPageRight").hide();
		} else {
			$('#results-bar').find('.pagination .page').show();
			$('#results-bar').find('.pagination').show().find('.page').hide();
			$('#results-bar').find('.page:lt('+ Results._paginationStages +')').show();
		};

		<%-- Show or hide filtered messages --%>
		var _n = Results._priceCount - Results.visiblePriceCount();
		if( _n > 0 ){
			$('#results-bar').find('h5').fadeIn().css('display','inline-block').find('span').text(_n);
		} else {
			$('#results-bar').find('h5').fadeOut().find('span').text(_n);
		};
	},

	<%-- Calculate pagination for all results --%>
	_pagination: function(){
		$('.current-results').css('left', '6px'); //reset the start point
		$('#results-bar').find('h5').hide();

		var nCount = Results._priceCount;
		Results._paginationStage = 1;
		Results._paginationOuter = Math.floor( $('#results-header .current-results > div:last').outerWidth(true));

		<%-- stages = amount of result-boxes in the step size (by total number of results) --%>
		Results._paginationStages =  Math.ceil( nCount / (Results._paginationStep / Results._paginationOuter) );

		<%-- reset the pagination and results count --%>
		$("#resultCount").text(nCount);
		var $Pages = $('#results-bar .pagination');
		$Pages.find('.page').remove();

		<%-- Loop and make the page-numbers (if required) --%>
		if(Results._paginationStages <= 1){
			$('#results-bar .pagination').hide();
			$("#viewMoreProducts").hide();
		} else {
			$("#viewMoreProducts").show();
			for (i=0; i < Results._paginationStages; i++) {
				$Pages.find('#HLT_MainRight').before('<div id="HLT_Main' + (i + 1) + '" class="page"><p>'+ (i +1) +'</p><div class="icon"><!-- empty --></div><div class="foot"><!-- empty --></div></div>');
			};
			$('#results-bar .pagination').show();
		};

		<%-- Bind the new pagination buttons --%>
		$('#results-bar .page').on('click', function(){
			Results._paginationAnimate($(this).find('p').first().text());
		});

		<%-- If an update has performed and a filter is applied, make sure the correct pagination is displayed --%>
		if (Results.visiblePriceCount() < Results._priceCount) {
			Results._paginationCurrent();
		}
		<%-- otherwise use _paginationAnimate to turn on/off the correct pagination states --%>
		else {
			Results._paginationAnimate(1);
		}
	},

	_paginationAnimate: function(index){
		<%-- Create the newStage index number --%>
		switch(index) {
			case '+':
				var newStage = parseInt(Results._paginationStage) + 1;
				break;
			case '-':
				var newStage = parseInt(Results._paginationStage) - 1;
				break;
			default:
				var newStage = index;
				break;
		};

		var prevStage =  parseInt(Results._paginationStage)+0;

		var offset=0;

		if (prevStage == 1){
			offset=25;
		} else if (newStage == 1) {
			offset=-25;
		}

		<%-- Animate slides --%>

		if(newStage != Results._paginationStage && newStage > 0 && newStage <= Results._paginationStages) {
			var steps = Results._paginationStage - newStage;

			$(".current-results").animate({
				left:'+='+((Results._paginationStep * steps)+offset) +'px'},1000,'easeOutQuart');

			Results._paginationStage = newStage;
		};

		<%-- Release disabled for two main buttons --%>
		if(Results._paginationStage == 1){
			$("#HLT_MainLeft").addClass('disabled');
			$("#HLT_InPageLeft").hide();
			preShadowState = 'none';
		} else {
			$("#HLT_MainLeft").removeClass('disabled');
			$("#HLT_InPageLeft").show();
			preShadowState = 'block';
		};
		if (Results._paginationStage >= Results._paginationStages) {
			$("#HLT_MainRight").addClass('disabled');
			$("#HLT_InPageRight").hide();
			nextShadowState = 'none';
		} else {
			$("#HLT_MainRight").removeClass('disabled');
			$("#HLT_InPageRight").show();
			nextShadowState = 'block';
		};

		<%-- Locate the active item --%>
		$('#results-bar .pagination .page').removeClass('active');
		$('#results-bar .pagination .page').eq(Results._paginationStage - 1).addClass('active');

	},

	paginate: function(index){
		Results._paginationAnimate(index);
	},

	resubmitForNewResults: function() {
		Results.hardReset( true );
		Results.softReset();

		<%-- Move user along --%>
		$('#slideErrorContainer').hide();
		healthPolicyDetails.destroy();
		QuoteEngine.gotoSlide({
			index:			2,
			noAnimation :	true
		});
		Health.fetchPrices(true);
	},

	startOver: function(){
		Results.hardReset();
		Results.softReset();

		<%-- Move user along --%>
		Results.hidePage();
		Loading.hide();
		$('#slideErrorContainer').hide();
		healthPolicyDetails.destroy();
		QuoteEngine.gotoSlide({
			index:	0
		});
	},

	hardReset: function( ignore_rebates_form ){

		ignore_rebates_form = ignore_rebates_form || false;

		<%-- Kill the product specific items --%>
		$('#health_application_provider, #health_application_productId, #health_application_productNumber').val('');
		Results._selectedProduct = false;
		healthPolicySnapshot.J_product = false;

		<%-- Reset the rebates form --%>
		if( ignore_rebates_form !== true ) {
		healthChoices.resetRebateForm();
		}
	},

	softReset: function(){
		<%-- Kill the Post-Results flags --%>
		healthPayment.priceChange();
		healthPolicySnapshot.destroy();
		delete JoinDeclarationDialog._product;
		healthFunds.unload();

		$("#health_payment_details_frequency option").first().prop("selected", "selected");

		$('#health_benefitsCloseBtn').trigger("click");

		<%-- Set up the first page to begin again --%>
		healthChoices._situationBenefit(false, 'cover');

		<%-- Reset the cover start date --%>
		$('#health_payment_details_start').val('');

		<%-- Set payment frequency back to Please Choose --%>
		$('#health_payment_details_frequency option').first().prop('selected', 'selected');
	},

	<%-- AJAX in the fund information into a dialog --%>
	_aboutFund: function(id){
		var _success = Health.fetchAbout(id);
		if( !_success ){
			FatalErrorDialog.exec({
				message:		'Error: We could not find the about fund information',
				page:			"health:results.tag",
				description:	"Results._aboutFund(). Error fetching About content for: " + id,
				data:			{id: id}
			});
		} else {
			var $_obj = $('#results-read-more');
			$_obj.find('.content').html(_success);
			$_obj.dialog("open");
		};
	}

}

jQuery.fn.sort = function() {
	return this.pushStack( [].sort.apply( this, arguments ), []);
};

</go:script>

<go:script marker="onready">
	if(typeof(SaveQuote) != 'undefined' && Health._mode != HealthMode.CONFIRMATION) {
		$(document).on(SaveQuote.confirmedEvent, function(event) {
			$('#save-your-quote span').text(SaveQuote.resaveText);
		});
	}

$("#edit-your-rebates").click(function(){
	Results.hidePage();
	QuoteEngine.gotoSlide({
		index:	1
	});
});

$("#save-your-quote").click(function(){
	SaveQuote.show();
});

$("#start-over").click(function(){
	Results.startOver();
});

<%-- Delegated Events --%>
$('#left-panel, #results-table').delegate('a.edit_benefits, #edit-your-benefits', 'click', function() {
	$('body,html').animate({
		scrollTop: 0
	}, 'fast', function(){
		if(!$('#health_benefitsContentContainer').is(':visible')) {
			$('#ChooseBenefits').trigger('click');
		}
	});
	return false;
});

$('#left-panel').delegate('.help_icon', 'click', function() {
	Help.update( $(this).attr('id').substring(5), $(this) );
});

$('#results-table').delegate('a.results-read-more', 'click', function() {
	Results._aboutFund( $(this).closest('.result-row').attr('data-fund')  );
});

<%-- Grab a result and for each 'row' expand the item to the highest height --%>
$('#results-container').delegate('.expandable', 'click', function(event) {
	if( event.target.nodeName == 'A'  ){
		return;
	};
	Results.expand( $(this).attr('data-id') );
});

<%-- Add the hover effect to each row --%>
$('#results-container').on('hover', '.expandable', function(event) {
	Results.hoverrow( $(this).attr('data-id'));
});

<%-- Compare binds delegated --%>
$('#results-header').find('.current-results').on('click', '.compare', function(event){
	var id = $(this).closest('.result-row ').attr('data-id');
	Compare.addRemove(id);
});

<%-- Bind buttons --%>
$('#basket').find('.content').find('.button').on('click', function(){ Compare.toggle(); });

$('#results-header').find('.current-results').on('click', '.apply-button a.applynow', function(event){
	var id = $(this).closest('.result-row ').attr('data-id');
	Results.applyNow( $(this).closest('.result-row') );
});

$('#results-header').find('.current-results').on('click', '.apply-button a.moredetails', function(event) {
	Results.showMoreInfo( this );
});




// Add the slider ui for adjusting the excess
// ==========================================
$('#change-excess .sliderWrapper').each(function() {
	var labels  = ['$0', '$1-$250', '$251-$500', 'All'];
	var min 	= 1;
	var max 	= 4;
	var related = $(this).find('input');
	var label 	= $(this).find('span');
	$(this).find('.slider').slider({
		'min': min,
		'max': max,
		'value': related.val(),
		'animate': true,
		change: function(event, ui) {
			$(related).val(ui.value);
			$(label).html(labels[ui.value-1]);
			QuoteEngine.poke();
			Health.fetchPrices( true );
		}
	});

	// Manually set the label
	$(label).html(labels[related.val()-1]);
});


// Update the UI for the radio buttons in the filters
// ==================================================
$(function() {
	$('#show-price').buttonset();
	$('#show-price input').each(function(){
		$(this).button( "option", "icons", {primary:'radio-icon'});
	});
	$('#show-price input').on('change', function(){
		Results.filter(true);
	});

	$('#rank-results-by').buttonset();
	$('#rank-results-by input').each(function(){
		$(this).button( "option", "icons", {primary:'radio-icon'});
	});
	$('#rank-results-by input').on('change', function(){
		Results.sort();
	});

});

// Add functionality to toggle the filters displayed
// =================================================
$(function() {
	var togglables = ["show-price","rank-results-by"];

	var toggleFilterOptions = function(e) {

		var id = $(e.target).attr("id").replace("-toggle", "");

		if( $("#" + id).is(":visible") )
		{
			$("#" + id).slideUp("fast", function(){
				$("#" + id).removeClass("open");
				$(e.target).removeClass("on");
			});
		}
		else
		{
			$("#" + togglables[id == togglables[0] ? 1 : 0] + "-toggle").removeClass("on");
			$(e.target).addClass("on");
			$("#" + togglables[id == togglables[0] ? 1 : 0]).slideUp("fast", function(){
				$("#" + togglables[id == togglables[0] ? 1 : 0]).removeClass("open");
				$("#" + id).slideToggle("fast", function(){
					$("#" + id).addClass("open");
				});
			});
		}
	};

	$('#show-price-toggle').on("click", toggleFilterOptions);
	$('#rank-results-by-toggle').on("click", toggleFilterOptions);
	$('#change-excess').addClass("open");
});


// Add dialog box for editing benefits from the results page
// =========================================================
$('#results-edit-benefits').dialog({
	autoOpen: false,
	show: 'clip',
	hide: 'clip',
	'modal':true,
	'width':639, 'height':680,
	'minWidth':639, 'minHeight':680,
	'autoOpen': false,
	'draggable':false,
	'resizable':false,
	'title':'Edit Benefits',
	'dialogClass':'results-edit-benefits-dialog',
	open: function() {
		$(".ui-dialog-titlebar a.ui-dialog-titlebar-close").eq(0).show();
		$('.ui-widget-overlay').bind('click', function () { $('#results-edit-benefits').dialog('close'); });
		$("#health_benefits").append("<a href='javascript:void(0);' id='results-edit-benefits-submit-button' class='button'><span>Search</span></a>");
		$("#results-edit-benefits-submit-button").click(function(){
			$('#results-edit-benefits').dialog("close");
			if( QuoteEngine.validate() ){
				QuoteEngine.preCompleted();
			};
		});
	},
	close: function(){
		$(".ui-dialog-titlebar a.ui-dialog-titlebar-close").eq(0).hide();
		$("#results-edit-benefits-submit-button").remove();
		$('#health-benefits').replaceWith( $('#results-edit-benefits') );
<%-- 	//FIX: need to be able to clone in original version, and than replace the 'edited' edit benefits with their updated version
		//NOTE: if is was not specifically saved - it should actually not update the benefits JSON list - so it requires some smarts
		//$('#results-edit-benefits').clone(true).appendTo('#health-benfits');
		//$("#health_situation").after( $("#health_benefits").detach() ); --%>
	}
});


<%-- Bind the pagination buttons --%>
$("#HLT_MainLeft, #HLT_InPageLeft").on('click', function(){
	Results._paginationAnimate('-');
});
$("#HLT_MainRight, #HLT_InPageRight").on('click', function(e){
	Results._paginationAnimate('+');
});

</go:script>

<c:set var="operatorClass">
	<c:if test="${not empty data['login/user/uid']}">operator</c:if>
</c:set>

<%-- HTML --%>
<div id="resultsPage" class="clearFix ${operatorClass}">

	<simples:dialogue id="28" vertical="health" mandatory="true" />
	<simples:dialogue id="32" vertical="health" className="green" />
	<simples:dialogue id="33" vertical="health" className="purple" />
	<simples:dialogue id="34" vertical="health" />

	<%-- the divider will keep dialogue and results seperate --%>
	<div id="results-divider">

		<div id="results-fixed">
			<div id="results-summary">
				<h1>Your Comparisons</h1>
				<h2 id="results-summary-text"></h2>
			</div>

			<health:results_benefits xpath="${xpath}/benefits" />
			
			<div style="clear:both"></div>
			<div class="compare-box" id="basket">
				<div id="compareMask"></div>
				<div class="row top"><!-- empty --></div>
				<div class="row mid">
					<h4>Compare your results</h4>
					<div class="content">
						<div class="basket-items"></div>
						<a href="javascript:void(0);" class="compare-selected button"><span>Compare selected</span></a>
					</div>
					<div class="status"></div>
				</div>
				<div class="row bot"><!-- empty --></div>
			</div>

			<%--  Shadow for next page --%>
			<%-- HLT_InPageLeft and HLT_InPageRight are IDs for SuperTag (previously was nextPageShadow/prevPageShadow --%>
			<div id="HLT_InPageRight">
				<span id="nextPageSlider"></span>
			</div>
			<div id="HLT_InPageLeft">
				<span id="prevPageSlider"></span>
			</div>

			<div id="results-fixed-mask"><!-- empty --></div>
			<div id="results-bar" class="result-bar-top">
					<h3><span id="resultCount">%d</span> Results <span class="thinFont">found</span></h3>
					<h5>(<span></span> hidden due to your filters)</h5>
					<div class="pagination">
						<img src="brand/ctm/images/viewMoreProducts.png" style="float:left;height:45px;"/>
						<%-- HLT_MainLeft and HLT_MainRight are IDs for SuperTag (previously was prev-results/next-results --%>
						<div id="HLT_MainLeft"><!-- empty --></div>
						<div id="HLT_MainRight"><!-- empty --></div>
					</div>
					<%-- <span id="viewMoreProducts">View more products</span> --%>
<%-- 					<div class="pagination">
						<img src="brand/ctm/images/viewMoreProducts.png" style="float:left;height:45px;"/>
						<div id="prev-results">&lt;</div>
						<div id="next-results">&gt;</div>
					</div> --%>

					</div>
			<div id="results-header" style="background: none">
				<div id="headerError" class="error"></div>
				<div class="current-results"></div>
			</div>
		</div>
		<div id="results-container" class="expandible-container">


			<div id="left-panel">
				<div class="box edit-selection">
					<div class="row top"><!-- empty --></div>
					<div class="row mid lt">
						<a href="javascript:void(0);" id="edit-your-rebates" class="button"><span>Edit Rebates</span></a>
						<a href="javascript:void(0);" id="save-your-quote" class="button"><span>Email Quote</span></a>
						<div style="clear:both;"><!-- empty --></div>
					</div>
					<div class="row bot lt"><!-- empty --></div>
				</div>
				<div class="box filter-selection">
					<div class="row top"><!-- empty --></div>
					<div class="row mid lt">
						<h4>Filter Results</h4>
						<div class="content">
							<h5 class="lt">By Payment Frequency<span id="show-price-toggle"><!-- toggle --></span></h5>
							<div id="show-price" class="">
								<field:array_radio xpath="health/show-price" title="show price"
										required="false" items="F=Fortnightly,M=Monthly,A=Annually" />
							</div>
							<h5 class="lt">Rank Results By<span id="rank-results-by-toggle"><!-- toggle --></span></h5>
							<div id="rank-results-by" class="">
								<field:array_radio xpath="health/rank-by" title="rank results by" required="false" items="B=Benefits,L=Lowest Price" />
							</div>
							<h5 class="lt">Change Excess</h5>
							<div id="change-excess" class="">
								<div><field:slider helpId="16" title="Excess: " id="health_excess" value="4" /></div>
							</div>

							<%-- Will be for the call centre only - not yet approved for the ONLINE journey --%>
							<c:if test="${callCentre}">
								<health:price_filter xpath="health_priceMin" id="change-price-min" />
							</c:if>

							<%-- Call Center Feature Only for now and not approved for ONLINE journey --%>
							<c:if test="${callCentre}">
								<health:brand_filter xpath="health_brandFilter" />
							</c:if>

						</div>
					</div>
					<div class="row bot lt"><!-- empty --></div>
				</div>

				<div id="matchCategoryHospital" class="box category-hospital">
					<div class="row top"><!-- empty --></div>
					<div class="row mid md"><!-- populated by template --></div>
					<div class="row bot md"><!-- empty --></div>
				</div>

				<div id="matchCategoryExtras" class="box category-extras">
					<div class="row top"><!-- empty --></div>
					<div class="row mid dk"><!-- populated by template --></div>
					<div class="row bot dk"><!-- empty --></div>
				</div>

				<div id="matchCategoryAmbulance" class="box ambulance">
					<div class="row top"><!-- empty --></div>
					<div class="row mid md">
						<div class="expandable" data-id="Ambulance">
							<h6>Ambulance <a href="javascript:void(0);"class="help_icon"  id="help_284"><!-- help --></a></h6>
							<p class="x3">Waiting period</p>
							<p class="x5">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
						</div>
						<div class="footer"></div>
					</div>
					<div class="row bot md"><!-- empty --></div>
				</div>

			</div>

			<div id="results-table" class="expandible-container">
				<div class="current-results"></div>
			</div>
		</div>

	</div>

	<%-- TEMPLATE: hospital inclusions labels --%>
	<core:js_template id="hospital-inclusions-labels-template">
		<h5>Hospital benefit inclusions</h5>
		<div class="non-expandable policy-link">
			<p>&nbsp;</p>
		</div>
		<div class="benefits-hospital-inclusions">
			<div class="excess non-expandable" data-id="ExcessType">
				<h6 class="x4">Excess<a href="javascript:void(0);"class="help_icon"  id="help_299"><!-- help --></a></h6>
			</div>
			<div class="waivers non-expandable" data-id="Waivers">
				<h6 class="x2">Excess Waivers<a href="javascript:void(0);"class="help_icon"  id="help_303"><!-- help --></a></h6>
			</div>
			<div class="copayment non-expandable" data-id="CoPaymentType">
				<h6 class="x4">Co-payment / % Hospital Contribution<a href="javascript:void(0);"class="help_icon"  id="help_300"><!-- help --></a></h6>
			</div>
			<div data-id="PreExisting" class="non-expandable">
				<h6>Pre Existing Waiting Period<a href="javascript:void(0);"class="help_icon"  id="help_301"><!-- help --></a></h6>
			</div>
			<div data-id="PuHospital" class="non-expandable">
				<h6>Public Hospital<a href="javascript:void(0);"class="help_icon"  id="help_254"><!-- help --></a></h6>
			</div>
			<div data-id="PrHospital" class="non-expandable">
				<h6>Private Hospital<a href="javascript:void(0);"class="help_icon"  id="help_253"><!-- help --></a></h6>
			</div>
		</div>
	</core:js_template>

	<%-- TEMPLATE: hospital benefits labels --%>
	<core:js_template id="hospital-benefits-labels-template">
		<h5>Selected benefits</h5>
		<div class="selected"></div>

		<h5>Other benefits</h5>
		<div class="benefits-hospital">
			<div class="expandable" data-id="Cardiac">
				<h6>Heart Surgery<a href="javascript:void(0);"class="help_icon"  id="help_255"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="Obstetric">
				<h6>Birth Related Services<a href="javascript:void(0);"class="help_icon"  id="help_256"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="AssistedReproductive">
				<h6>Assisted Reproduction <a href="javascript:void(0);"class="help_icon"  id="help_257"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="CataractEyeLens">
				<h6>Major Eye Surgery<a href="javascript:void(0);"class="help_icon"  id="help_258"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="JointReplacement">
				<h6>Joint Replacement<a href="javascript:void(0);"class="help_icon"  id="help_259"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="PlasticNonCosmetic">
				<h6 class="longLabel">Non Cosmetic Plastic Surgery<a href="javascript:void(0);"class="help_icon"  id="help_260"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<%-- DEPRECATED
			<div class="expandable" data-id="Podiatric">
				<h6>Surgery by Podiatrist<a href="javascript:void(0);"class="help_icon"  id="help_261"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			--%>
			<div class="expandable" data-id="Sterilisation">
				<h6>Sterilisation<a href="javascript:void(0);"class="help_icon"  id="help_262"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="GastricBanding">
				<h6>Gastric Banding<a href="javascript:void(0);"class="help_icon"  id="help_263"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="RenalDialysis">
				<h6>Dialysis<a href="javascript:void(0);"class="help_icon"  id="help_264"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p>Benefit Limitation Period <a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="Palliative">
				<h6>Palliative Care<a href="javascript:void(0);"class="help_icon"  id="help_265"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p class="x2">Benefit Limitation Period /<br />Other comments<a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="Psychiatric">
				<h6>In-Hospital Psychiatry<a href="javascript:void(0);"class="help_icon"  id="help_266"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p class="x2">Benefit Limitation Period /<br />Other comments<a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
			<div class="expandable" data-id="Rehabilitation">
				<h6>In-Hospital Rehabilitation<a href="javascript:void(0);"class="help_icon"  id="help_267"><!-- help --></a></h6>
				<p>Waiting period</p>
				<p class="x2">Benefit Limitation Period /<br />Other comments<a href="javascript:void(0);"class="help_icon"  id="help_401"><!-- help --></a></p>
			</div>
		</div>
		<div class="footer">
			<c:choose>
				<c:when test="${not empty callCentre}">
					<div class="exclusions_cover">Special Conditions</div>
				</c:when>
				<c:otherwise>
					<a href="#" class="edit_benefits"><span>Edit Hospital Benefits</span></a>
				</c:otherwise>
			</c:choose>
		</div>
	</core:js_template>


	<%-- TEMPLATE: extras labels --%>
	<core:js_template id="extras-labels-template">
		<h5>Selected extras</h5>
		<div class="non-expandable policy-link">
			<p>&nbsp;</p>
		</div>
		<div class="selected"></div>
		<h5>Other extras</h5>
		<div class="benefits-extras">
			<div class="expandable" data-id="DentalGeneral">
				<h6>General Dental<a href="javascript:void(0);"class="help_icon"  id="help_269"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p class="x2">Periodic oral examination<br /> (Item Number 012)</p>
				<p>Scale and Clean (Item Number 114)</p>
				<p>Flouride Treatment (Item Number 121)</p>
				<p class="x2">Surgical Tooth Extraction<br /> (Item Number 322)</p>
				<p class="x3">Special features</p>
			</div>
			<div class="expandable" data-id="DentalMajor">
				<h6>Major Dental<a href="javascript:void(0);"class="help_icon"  id="help_270"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p class="x2">Surgical Tooth Extraction<br /> (Item Number 322)</p>
				<p class="x2">Full Crown Veneered<br /> (Item Number 615)</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="Endodontic">
				<h6>Endodontic <a href="javascript:void(0);"class="help_icon"  id="help_271"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p class="x2">Filling of 1 root canal<br /> (Item Number 417)</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="Orthodontic">
				<h6>Orthodontic <a href="javascript:void(0);"class="help_icon"  id="help_272"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>lifetime limit</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p class="x2">Braces for upper and lower teeth including retainer(Item Number 881)</p>
				<p class="x3">Special features</p>
			</div>
			<div class="expandable" data-id="Optical">
				<h6>Optical <a href="javascript:void(0);"class="help_icon"  id="help_273"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p class="x2">Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Single vision lenses and frames</p>
				<p>Multi-focal lenses and frames</p>
			</div>
			<div class="expandable" data-id="Physiotherapy">
				<h6>Physiotherapy <a href="javascript:void(0);"class="help_icon"  id="help_274"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="Chiropractic">
				<h6>Chiropractic <a href="javascript:void(0);"class="help_icon"  id="help_275"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="Podiatry">
				<h6>Podiatry <a href="javascript:void(0);"class="help_icon"  id="help_276"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="Acupuncture">
				<h6>Acupuncture <a href="javascript:void(0);"class="help_icon"  id="help_277"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="Naturopath">
				<h6>Naturopathy<a href="javascript:void(0);"class="help_icon"  id="help_278"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="Massage">
				<h6>Remedial Massage <a href="javascript:void(0);"class="help_icon"  id="help_279"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="Psychology">
				<h6>Psychology <a href="javascript:void(0);"class="help_icon"  id="help_280"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x4">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="GlucoseMonitor">
				<h6>Glucose Monitor <a href="javascript:void(0);"class="help_icon"  id="help_281"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>per monitor</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="HearingAid">
				<h6>Hearing Aids <a href="javascript:void(0);"class="help_icon"  id="help_282"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>per hearing aid</p>
				<p>Special features</p>
			</div>
			<div class="expandable" data-id="NonPBS">
				<h6>Non PBS Pharmaceuticals<a href="javascript:void(0);"class="help_icon"  id="help_283"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>per eligible prescription</p>
				<p>Special features</p>
			</div>
			<%-- Additional Benefit Extras --%>
			<div class="expandable" data-id="Orthotics">
				<h6>Orthotics <a href="javascript:void(0);"class="help_icon"  id="help_298"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p class="x3">Benefit rebate examples</p>
			</div>
			<div class="expandable" data-id="SpeechTherapy">
				<h6>Speech Therapy <a href="javascript:void(0);"class="help_icon"  id="help_297"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="OccupationalTherapy">
				<h6>Occupational Therapy <a href="javascript:void(0);"class="help_icon"  id="help_296"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p class="x3">Initial visit</p>
				<p class="x3">Subsequent visit</p>
			</div>
			<div class="expandable" data-id="Dietetics">
				<h6>Dietetics <a href="javascript:void(0);"class="help_icon"  id="help_295"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="EyeTherapy">
				<h6>Eye Therapy <a href="javascript:void(0);"class="help_icon"  id="help_294"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p>Benefit rebate examples</p>
				<p>Initial visit</p>
				<p>Subsequent visit</p>
			</div>
			<div class="expandable" data-id="LifestyleProducts">
				<h6>Lifestyle Products <a href="javascript:void(0);"class="help_icon"  id="help_293"><!-- help --></a></h6>
				<p>per person</p>
				<p>per policy</p>
				<p>Waiting period</p>
				<p class="x3">Limits<br /> <span class="msg">(See policy brochure for full details of group limits and sub-limits)</span></p>
				<p class="x3">Loyalty Bonus per person</p>
				<p class="x4">Benefit rebate examples</p>
			</div>

			<div class="expandable" data-id="SpecialFeatures">
				<h6>Special Features</h6>
				<p class="x20"></p>
			</div>
		</div>
		<div class="footer">
			<c:choose>
				<c:when test="${not empty callCentre}">
					<div class="exclusions_cover">Special Conditions</div>
				</c:when>
				<c:otherwise>
					<a href="#" class="edit_benefits"><span>Edit Extras Benefits</span></a>
				</c:otherwise>
			</c:choose>
		</div>
	</core:js_template>


	<%-- TEMPLATE: footer --%>
	<core:js_template id="footer-template">
		<div class="footer">
			<c:choose>
				<c:when test="${not empty callCentre}">
					<div class="exclusions_cover">Special Conditions</div>
				</c:when>
				<c:otherwise>
					<a href="#" class="edit_benefits"><span>Edit Extras Benefits</span></a>
				</c:otherwise>
			</c:choose>
		</div>
	</core:js_template>

	<%-- TEMPLATE: result header --%>
	<core:js_template id="result-header-template">
		<div id="resultHdr_[#= productId #]" class="result-row [#= restrictedFundClass #]" data-id="[#= productId #]">
			<div class="FIX" style="position:absolute;top:-50px;left:auto;color:pink;">[#= productCode #]</div><%-- //FIX: this is for dev testing only --%>
			<div class="thumb"><img src="common/images/logos/health/[#= provider #].png?_=2" alt="[#= providerName #]"/></div>
			<div class="premium" data-text="[#= premium.monthly.text #]" data-lhcfreetext="[#= premium.monthly.lhcfreetext #]"><strong>[#= premium.monthly.lhcfreetext #]</strong> <span class="frequency">Per Month</span></div>
			<health:alt_premium />
			<h4 class="fund" style=""><a href="javascript:void(0);"><!-- empty --><div class="restricted_help"><!-- empty --></div></a><span>[#= name #]</span></h4>
			<div class="pricing">[#= premium.annually.lhcfreepricing #]</div>
			<div class="buttons">
				<div class="apply-button">
					<a href="javascript:void(0)" class="moredetails" title="More details"><!-- button --></a>
					<a href="javascript:void(0)" class="applynow" title="Apply now"><!-- button --></a>
					<div class="text"><!-- call us --></div>
				</div>
				<div class="compare-button"><a class="compare button" href="javascript:void(0)">Select to compare</a></div>

			</div>
		</div>
	</core:js_template>

	<%-- TEMPLATE: result table --%>
	<core:js_template id="result-table-template">
			<div id="resultRow_[#= productId #]" class="expandible-container result-row" data-id="[#= productId #]" data-fund="[#= provider #]">
				<div class="matchDataDetails"></div>
				<div class="matchDataHospital"></div>
				<div class="matchDataExtras"></div>
				<div class="matchDataAmbulance"></div>
			</div>
	</core:js_template>


	<%-- TEMPLATE: hospital inclusions --%>
	<core:js_template id="hospital-inclusions-template">
		<h5>Hospital benefits</h5>
		<div class="non-expandable policy-link">
			<p>For full details of hospital benefits included for this policy <a href="/${data.settings.styleCode}/[#= hospitalPDF #]" target="_blank">see the policy brochure</a></p>
		</div>
		<div class="benefits-hospital-inclusions">
			<div class="non-expandable" data-id="ExcessType">
				<h6 class="x4">[#= excess #]  &nbsp;</h6>
			</div>
			<div class="non-expandable" data-id="Waivers">
				<h6 class="x2">[#= waivers #]  &nbsp;</h6>
			</div>
			<div class="non-expandable" data-id="CoPaymentType">
				<h6 class="x4">[#= copayment #] &nbsp;</h6>
			</div>
			<div class="non-expandable" data-id="PreExisting">
				<h6>[#= waitingPeriods.PreExisting #] &nbsp;</h6>
			</div>
			<div class="non-expandable [#= publicHospital #]" data-id="PuHospital">
				<h6>[#= publicHospital #] &nbsp;</h6>
			</div>
			<div class="non-expandable [#= privateHospital #]" data-id="PrHospital">
				<h6>[#= privateHospital #] &nbsp;</h6>
			</div>
		</div>
	</core:js_template>


	<%-- TEMPLATE: hospital benefits --%>
	<core:js_template id="hospital-benefits-template">
		<h5>Selected benefits</h5>
		<div class="selected"></div>

		<h5>Other benefits</h5>
		<div class="benefits-hospital">
			<div class="expandable [#= Cardiac.covered #]" data-id="Cardiac">
				<h6>[#= Cardiac.covered #] &nbsp;</h6>
				<p>[#= Cardiac.WaitingPeriod #] &nbsp;</p>
				<p>[#= Cardiac.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= Obstetric.covered #]" data-id="Obstetric">
				<h6>[#= Obstetric.covered #] &nbsp;</h6>
				<p>[#= Obstetric.WaitingPeriod #] &nbsp;</p>
				<p>[#= Obstetric.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= AssistedReproductive.covered #]" data-id="AssistedReproductive">
				<h6>[#= AssistedReproductive.covered #] &nbsp;</h6>
				<p>[#= AssistedReproductive.WaitingPeriod #] &nbsp;</p>
				<p>[#= AssistedReproductive.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= CataractEyeLens.covered #]" data-id="CataractEyeLens">
				<h6>[#= CataractEyeLens.covered #] &nbsp;</h6>
				<p>[#= CataractEyeLens.WaitingPeriod #] &nbsp;</p>
				<p>[#= CataractEyeLens.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= JointReplacement.covered #]" data-id="JointReplacement">
				<h6>[#= JointReplacement.covered #] &nbsp;</h6>
				<p>[#= JointReplacement.WaitingPeriod #] &nbsp;</p>
				<p>[#= JointReplacement.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= PlasticNonCosmetic.covered #]" data-id="PlasticNonCosmetic">
				<h6>[#= PlasticNonCosmetic.covered #] &nbsp;</h6>
				<p>[#= PlasticNonCosmetic.WaitingPeriod #] &nbsp;</p>
				<p>[#= PlasticNonCosmetic.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<%-- DEPRECATED
			<div class="expandable [#= Podiatric.covered #]" data-id="Podiatric">
				<h6>[#= Podiatric.covered #]</h6>
				<p>[#= Podiatric.WaitingPeriod #]</p>
				<p>[#= Podiatric.benefitLimitationPeriod #]</p>
			</div>
			--%>
			<div class="expandable [#= Sterilisation.covered #]" data-id="Sterilisation">
				<h6>[#= Sterilisation.covered #] &nbsp;</h6>
				<p>[#= Sterilisation.WaitingPeriod #] &nbsp;</p>
				<p>[#= Sterilisation.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= GastricBanding.covered #]" data-id="GastricBanding">
				<h6>[#= GastricBanding.covered #] &nbsp;</h6>
				<p>[#= GastricBanding.WaitingPeriod #] &nbsp;</p>
				<p>[#= GastricBanding.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= RenalDialysis.covered #]" data-id="RenalDialysis">
				<h6>[#= RenalDialysis.covered #] &nbsp;</h6>
				<p>[#= RenalDialysis.WaitingPeriod #] &nbsp;</p>
				<p>[#= RenalDialysis.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= Palliative.covered #]" data-id="Palliative">
				<h6>[#= Palliative.covered #] &nbsp;</h6>
				<p>[#= Palliative.WaitingPeriod #] &nbsp;</p>
				<p class="x2">[#= Palliative.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= Psychiatric.covered #]" data-id="Psychiatric">
				<h6>[#= Psychiatric.covered #] &nbsp;</h6>
				<p>[#= Psychiatric.WaitingPeriod #] &nbsp;</p>
				<p class="x2">[#= Psychiatric.benefitLimitationPeriod #] &nbsp;</p>
			</div>
			<div class="expandable [#= Rehabilitation.covered #]" data-id="Rehabilitation">
				<h6>[#= Rehabilitation.covered #] &nbsp;</h6>
				<p>[#= Rehabilitation.WaitingPeriod #] &nbsp;</p>
				<p class="x2">[#= Rehabilitation.benefitLimitationPeriod #] &nbsp;</p>
			</div>
		</div>
		<div class="footer">
			<c:choose>
				<c:when test="${not empty callCentre}">
					<div class="exclusions_cover">[#= exclusions.cover #]</div>
				</c:when>
				<c:otherwise>
					<a href="javascript:void(0);" class="edit_benefits"><span>Edit Hospital Benefits</span></a>
				</c:otherwise>
			</c:choose>
		</div>
	</core:js_template>


	<%-- TEMPLATE: extras --%>
	<core:js_template id="extras-template">

		<h5>Selected extras</h5>
		<div class="non-expandable policy-link">
			<p>For full details of extras included for this policy <a href="/${data.settings.styleCode}/[#= extrasPDF #]" target="_blank">see the policy brochure</a></p>
		</div>
		<div class="selected"></div>

		<h5>Other extras</h5>
		<div class="benefits-extras">
			<div class="expandable [#= DentalGeneral.covered #]" data-id="DentalGeneral">
				<h6>[#= DentalGeneral.covered #] &nbsp;</h6>
				<p>[#= DentalGeneral.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= DentalGeneral.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= DentalGeneral.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= DentalGeneral.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= DentalGeneral.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p class="x2">[#= DentalGeneral.benefits.DentalGeneral012PeriodicExam #] &nbsp;</p>
				<p>[#= DentalGeneral.benefits.DentalGeneral114ScaleClean #] &nbsp;</p>
				<p>[#= DentalGeneral.benefits.DentalGeneral121Fluoride #] &nbsp;</p>
				<p class="x2">[#= DentalGeneral.benefits.DentalGeneral322Extraction #] &nbsp;</p>
				<p class="x3">[#= DentalGeneral.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= DentalMajor.covered #]" data-id="DentalMajor">
				<h6>[#= DentalMajor.covered #] &nbsp;</h6>
				<p>[#= DentalMajor.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= DentalMajor.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= DentalMajor.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= DentalMajor.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= DentalMajor.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p class="x2">[#= DentalMajor.benefits.DentalMajor322Extraction #] &nbsp;</p>
				<p class="x2">[#= DentalMajor.benefits.DentalMajor615FullCrownVeneered #] &nbsp;</p>
				<p>[#= DentalMajor.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= Endodontic.covered #]" data-id="Endodontic">
				<h6>[#= Endodontic.covered #] &nbsp;</h6>
				<p>[#= Endodontic.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Endodontic.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Endodontic.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Endodontic.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Endodontic.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p class="x2">[#= Endodontic.benefits.Endodontic417RootCanalTherapy #] &nbsp;</p>
				<p>[#= Endodontic.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= Orthodontic.covered #]" data-id="Orthodontic">
				<h6>[#= Orthodontic.covered #] &nbsp;</h6>
				<p>[#= Orthodontic.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Orthodontic.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Orthodontic.benefitLimits.lifetime #] &nbsp;</p>
				<p>[#= Orthodontic.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Orthodontic.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Orthodontic.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p class="x2">[#= Orthodontic.benefits.Orthodontic881BracesUpperLowerPlusRetainer #] &nbsp;</p>
				<p class="x3">[#= Orthodontic.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= Optical.covered #]" data-id="Optical">
				<h6>[#= Optical.covered #] &nbsp;</h6>
				<p>[#= Optical.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Optical.benefitLimits.perPolicy #] &nbsp;</p>
				<p class="x2">[#= Optical.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Optical.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Optical.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Optical.benefits.OpticalSingleVisionLenses #] &nbsp;</p>
				<p>[#= Optical.benefits.OpticalMultiFocalLenses #] &nbsp;</p>
			</div>
			<div class="expandable [#= Physiotherapy.covered #]" data-id="Physiotherapy">
				<h6>[#= Physiotherapy.covered #]</h6>
				<p>[#= Physiotherapy.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Physiotherapy.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Physiotherapy.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Physiotherapy.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Physiotherapy.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Physiotherapy.benefits.PhysiotherapyInitial #] &nbsp;</p>
				<p>[#= Physiotherapy.benefits.PhysiotherapySubsequent #] &nbsp;</p>
				<p>[#= Physiotherapy.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= Chiropractic.covered #]" data-id="Chiropractic">
				<h6>[#= Chiropractic.covered #] &nbsp;</h6>
				<p>[#= Chiropractic.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Chiropractic.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Chiropractic.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Chiropractic.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Chiropractic.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Chiropractic.benefits.ChiropracticInitial #] &nbsp;</p>
				<p>[#= Chiropractic.benefits.ChiropracticSubsequent #] &nbsp;</p>
				<p>[#= Chiropractic.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= Podiatry.covered #]" data-id="Podiatry">
				<h6>[#= Podiatry.covered #] &nbsp;</h6>
				<p>[#= Podiatry.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Podiatry.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Podiatry.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Podiatry.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Podiatry.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Podiatry.benefits.PodiatryInitial #] &nbsp;</p>
				<p>[#= Podiatry.benefits.PodiatrySubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= Acupuncture.covered #]" data-id="Acupuncture">
				<h6>[#= Acupuncture.covered #] &nbsp;</h6>
				<p>[#= Acupuncture.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Acupuncture.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Acupuncture.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Acupuncture.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Acupuncture.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Acupuncture.benefits.AcupunctureInitial #] &nbsp;</p>
				<p>[#= Acupuncture.benefits.AcupunctureSubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= Naturopathy.covered #]" data-id="Naturopath">
				<h6>[#= Naturopathy.covered #] &nbsp;</h6>
				<p>[#= Naturopathy.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Naturopathy.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Naturopathy.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Naturopathy.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Naturopathy.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Naturopathy.benefits.NaturopathyInitial #] &nbsp;</p>
				<p>[#= Naturopathy.benefits.NaturopathySubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= Massage.covered #]" data-id="Massage">
				<h6>[#= Massage.covered #] &nbsp;</h6>
				<p>[#= Massage.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Massage.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Massage.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Massage.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Massage.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Massage.benefits.MassageRemedialInitial #] &nbsp;</p>
				<p>[#= Massage.benefits.MassageSubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= Psychology.covered #]" data-id="Psychology">
				<h6>[#= Psychology.covered #] &nbsp;</h6>
				<p>[#= Psychology.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Psychology.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Psychology.waitingPeriod #] &nbsp;</p>
				<p class="x4">[#= Psychology.benefitLimits.combinedLimit #] &nbsp;</p>
				<p class="x3">[#= Psychology.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Psychology.benefits.PsychologyInitial #] &nbsp;</p>
				<p>[#= Psychology.benefits.PsychologySubsequent #] &nbsp;</p>
				<p>[#= Psychology.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= GlucoseMonitor.covered #]" data-id="GlucoseMonitor">
				<h6>[#= GlucoseMonitor.covered #] &nbsp;</h6>
				<p>[#= GlucoseMonitor.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= GlucoseMonitor.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= GlucoseMonitor.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= GlucoseMonitor.benefitLimits.combinedLimit #]<br />[#= GlucoseMonitor.benefitLimits.serviceLimit #] &nbsp;</p>
				<p class="x3">[#= GlucoseMonitor.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= GlucoseMonitor.benefits.BloodGlucoseMonitor #] &nbsp;</p>
				<p>[#= GlucoseMonitor.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= HearingAids.covered #]" data-id="HearingAid">
				<h6>[#= HearingAids.covered #] &nbsp;</h6>
				<p>[#= HearingAids.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= HearingAids.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= HearingAids.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= HearingAids.benefitLimits.combinedLimit #]<br />[#= HearingAids.benefitLimits.serviceLimit #] &nbsp;</p>
				<p class="x3">[#= HearingAids.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= HearingAids.benefits.HearingAid #] &nbsp;</p>
				<p>[#= HearingAids.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<div class="expandable [#= NonPBS.covered #]" data-id="NonPBS">
				<h6>[#= NonPBS.covered #]</h6>
				<p>[#= NonPBS.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= NonPBS.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= NonPBS.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= NonPBS.benefitLimits.combinedLimit #] [#= NonPBS.benefitLimits.serviceLimit #] &nbsp;</p>
				<p class="x3">[#= NonPBS.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= NonPBS.benefits.NonPBSPrescription #] &nbsp;</p>
				<p>[#= NonPBS.hasSpecialFeatures #] &nbsp;</p>
			</div>
			<%-- Additional Benefit Extras --%>
			<div class="expandable [#= Orthotics.covered #]" data-id="Orthotics">
				<h6>[#= Orthotics.covered #] &nbsp;</h6>
				<p>[#= Orthotics.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Orthotics.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Orthotics.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= Orthotics.groupLimit.codes #] &nbsp;</p>
				<p class="x3">[#= Orthotics.loyaltyBonus.perPerson #] &nbsp;</p>
				<p class="x3">[#= Orthotics.listBenefitExample #] &nbsp;</p>
			</div>
			<div class="expandable [#= SpeechTherapy.covered #]" data-id="SpeechTherapy">
				<h6>[#= SpeechTherapy.covered #] &nbsp;</h6>
				<p>[#= SpeechTherapy.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= SpeechTherapy.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= SpeechTherapy.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= SpeechTherapy.groupLimit.codes #] &nbsp;</p>
				<p class="x3">[#= SpeechTherapy.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= SpeechTherapy.benefitPayableInitial #] &nbsp;</p>
				<p>[#= SpeechTherapy.benefitpayableSubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= OccupationalTherapy.covered #]" data-id="OccupationalTherapy">
				<h6>[#= OccupationalTherapy.covered #] &nbsp;</h6>
				<p>[#= OccupationalTherapy.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= OccupationalTherapy.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= OccupationalTherapy.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= OccupationalTherapy.groupLimit.codes #] &nbsp;</p>
				<p class="x3">[#= OccupationalTherapy.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p class="x3">[#= OccupationalTherapy.benefitPayableInitial #] &nbsp;</p>
				<p class="x3">[#= OccupationalTherapy.benefitpayableSubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= Dietetics.covered #]" data-id="Dietetics">
				<h6>[#= Dietetics.covered #] &nbsp;</h6>
				<p>[#= Dietetics.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= Dietetics.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= Dietetics.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= Dietetics.groupLimit.codes #] &nbsp;</p>
				<p class="x3">[#= Dietetics.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= Dietetics.benefitPayableInitial #] &nbsp;</p>
				<p>[#= Dietetics.benefitpayableSubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= EyeTherapy.covered #]" data-id="EyeTherapy">
				<h6>[#= EyeTherapy.covered #] &nbsp;</h6>
				<p>[#= EyeTherapy.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= EyeTherapy.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= EyeTherapy.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= EyeTherapy.groupLimit.codes #] &nbsp;</p>
				<p class="x3">[#= EyeTherapy.loyaltyBonus.perPerson #] &nbsp;</p>
				<p>&nbsp;</p>
				<p>[#= EyeTherapy.benefitPayableInitial #] &nbsp;</p>
				<p>[#= EyeTherapy.benefitpayableSubsequent #] &nbsp;</p>
			</div>
			<div class="expandable [#= LifestyleProducts.covered #]" data-id="LifestyleProducts">
				<h6>[#= LifestyleProducts.covered #] &nbsp;</h6>
				<p>[#= LifestyleProducts.benefitLimits.perPerson #] &nbsp;</p>
				<p>[#= LifestyleProducts.benefitLimits.perPolicy #] &nbsp;</p>
				<p>[#= LifestyleProducts.waitingPeriod #] &nbsp;</p>
				<p class="x3">[#= LifestyleProducts.groupLimit.codes #] &nbsp;</p>
				<p class="x3">[#= LifestyleProducts.loyaltyBonus.perPerson #] &nbsp;</p>
				<p class="x4">[#= LifestyleProducts.listBenefitExample #] &nbsp;</p>
			</div>

			<div class="expandable [#= hasSpecialFeatures #]" data-id="SpecialFeatures">
				<h6>[#= hasSpecialFeatures #] &nbsp;</h6>
				<p class="x20">[#= SpecialFeatures #] &nbsp;</p>
			</div>
			<div class="footer">
				<c:choose>
					<c:when test="${not empty callCentre}">
						<div class="exclusions_cover">[#= exclusions.cover #]</div>
					</c:when>
					<c:otherwise>
						<a href="#" class="edit_benefits"><span>Edit Extras Benefits</span></a>
					</c:otherwise>
				</c:choose>
			</div>
	</core:js_template>


	<%-- TEMPLATE: ambulance --%>
	<core:js_template id="ambulance-template">
		<div class="expandable [#= covered #]" data-id="Ambulance">
			<h6>[#= covered #]</h6>
			<p class="x3">[#= waitingPeriod #] &nbsp;</p>
			<p class="x5">[#= otherInformation #] &nbsp;</p>
		</div>
		<div class="footer"></div>
	</core:js_template>


	<%-- TEMPLATE: details --%>
	<core:js_template id="details-template">
		<div class="non-expandable first-child">
			<div>[#= discountText #] &nbsp;</div>
		</div>
		<div class="non-expandable last-child">
			<h5>Promotions &amp; offers</h5>
			<div>[#= promoText #] &nbsp;</div>
		</div>
		<div class="footer"><a href="javascript:void(0);" class="results-read-more"><span>About the fund</span></a></div>
	</core:js_template>
</div>