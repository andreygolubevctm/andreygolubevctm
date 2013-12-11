<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:set var="transactionId">
	<c:choose>
		<c:when test="${not empty param.transactionid}">${transactionid}</c:when>
		<c:when test="${not empty data['current/transactionId']}">${data['current/transactionId']}</c:when>
		<c:when test="${not empty data['quote/transactionId']}">${data['quote/transactionId']}</c:when>
		<c:when test="${not empty data['health/transactionId']}">${data['health/transactionId']}</c:when>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="holiday-hours-dialog" class="holiday-hours-dialog" title="Search Health Quotes">
	<div class="innertube">
		<div class="entry-content">
				Monday 23rd December – 8.30am to 8pm<br>
				Tuesday 24th December – 8.30am to 1pm<br>
				Wednesday 25th December – Closed<br>
				Thursday 26th December – Closed<br>
				Friday 27th December – 8.30am to 1pm<br>
				Saturday 28th December – Closed<br>
				Sunday 29th December – Closed<br>
				Monday 30th December – 8.30am to 8pm<br>
				Tuesday 31st December – 8.30am to 1pm<br>
				Wednesday 1st January – Closed<br>
				Thursday 2nd January – 8.30am to 8pm<br>
				Friday 3rd January – 8.30am to 6pm
		</div>
		<div class="dialog_footer"></div>
	</div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
#holiday-hours-dialog {
	display: 				none;
	overflow:				hidden;
	position: static;
}

#holiday-hours-dialog .entry-content {
	line-height: 1.3em;
}

#holiday-hours-dialog h2 {
	margin:24px 0px;
	font-size:1.5em;
}
#holiday-hours-dialog h3 em {
	font-style:normal;
	color:#0CB24E;
}
#holiday-hours-dialog .clear{clear:both;}

#holiday-hours-dialog .innertube {
	margin:					0 20px;
}

#holiday-hours-dialog h3,
#holiday-hours-dialog p {
	font-size:				14px;
}

#holiday-hours-dialog h3 {
	font-weight:			900;
	margin:					15px 0 5px 0;
}

#holiday-hours-dialog h3:first-child {
	margin-top:				0;
}

#holiday-hours-dialog p {
	margin:					8px 0;
	font-size:				13px;
	line-height:			15px;
}

#holiday-hours-dialog .innertube th,
#holiday-hours-dialog .innertube td {
	padding:				5px 10px;
	border:					1px solid #E3E8EC;
	text-align:				left;
}

#holiday-hours-dialog .innertube th {
	font-weight:			900;
}

#holiday-hours-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_540.gif") no-repeat scroll left top transparent;
	height: 				14px;
	clear: 					both;
	width: 					540px;
}

.ui-dialog.holiday-hours-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog.holiday-hours-dialog .message-form, .ui-dialog #holiday-hours-dialog{
	padding:				0;
}

.holiday-hours-dialog .ui-dialog-titlebar {
	background-image:		url("common/images/dialog/header_540.gif") !important;
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

.holiday-hours-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_540.png") !important;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var HolidayHoursInfoDialog = new Object();
HolidayHoursInfoDialog = {

	init: function() {

		// Initialise the search quotes dialog box
		// =======================================
		$('#holiday-hours-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip',
			'modal':true,
			'width':540, 'height':300,
			'minWidth':400, 'minHeight':200,
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'holiday-hours-dialog',
			'title':'Christmas/New Year Period Operating Hours:',
			open: function() {
				HolidayHoursInfoDialog.show();
				$('.ui-widget-overlay').bind('click', function () { $("#holiday-hours-dialog").dialog('close'); });
			},
			close: function(){
				HolidayHoursInfoDialog.hide();
			}
		});
	},

	launch: function() {
		$('#holiday-hours-dialog').dialog("open");
	},

	hide: function() {
		$("#holiday-hours-dialog").hide();
	},

	show: function() {
		$("#holiday-hours-dialog").show();
		Track.onCustomPage("Rebates Info Dialog");
	}
};
</go:script>
<go:script marker="onready">
HolidayHoursInfoDialog.init();
</go:script>