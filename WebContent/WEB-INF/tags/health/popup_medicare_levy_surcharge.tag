<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="medicare-levy-surcharge-dialog" class="medicare-levy-surcharge-dialog" title="Search Health Quotes">
	<div class="innertube">

<h3>What is the Medicare Levy Surcharge?</h3>
		<p>The Medicare Levy Surcharge is an extra tax levied on higher income earners who don't hold hospital cover. The purpose of the Surcharge is to encourage more people to take out private health insurance and ease the burden on the public health care system.</p> 
		<h3>How much is the Medicare Levy Surcharge?</h3>
		<p>The Medicare Levy Surcharge is dependent on your taxable income.</p>
		
		<div class="spacesaver">
			<h3>2013-2014 Medicare Levy Surcharge for singles</h3>
			<table>
			<thead>
				<tr>
					<th>Income threshold</th>
					<th>Medicare Levy Surcharge</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Under $88,000</td>
					<td>0.00%</td>
				</tr>
				<tr>
					<td>$88,001-102,000</td>
					<td>1.00%</td>
				</tr>
				<tr>
					<td>$102,001-136,000</td>
					<td>1.25%</td>
				</tr>
				<tr>
					<td>Over $136,001</td>
					<td>1.50%</td>
				</tr>
			</tbody>
			</table>
		</div>
		
		<div class="spacesaver right">
			<h3>2013-2014 Medicare Levy Surcharge for couples and families</h3>
			<table>
			<thead>
				<tr>
					<th>Income threshold</th>
					<th>Medicare Levy Surcharge</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Under $176,000</td>
					<td>0.00%</td>
				</tr>
				<tr>
					<td>$176,001-$204,000</td>
					<td>1.00%</td>
				</tr>
				<tr>
					<td>$204,001-$272,000</td>
					<td>1.25%</td>
				</tr>
				<tr>
					<td>Over $272,000</td>
					<td>1.50%</td>
				</tr>
			</tbody>
			</table>								
		</div>
		
		<p>This includes single parent families.</p>
		
		<p>The income thresholds are adjusted for families with more than one child, being increased by $1,500 for every dependent child after the first.</p>
		<h3>Can I avoid the Medicare Levy Surcharge?</h3>
		<p>You can avoid paying the additional tax simply by taking out eligible private hospital cover. In order to be eligible, your hospital cover must be with a registered Australian health fund (all of our participating health funds are registered) and have an excess or co-payment no greater than $500 for singles policies or $1,000 for couples or family policies.</p>

		<h4>Additional considerations</h4>

		<h3>Medicare Levy Surcharge vs Medicare Levy</h3>
		<p>The Medicare Levy is a 1.5% tax that is paid by most taxpayers and is different to the Medicare Levy Surcharge, as it is not dependent on holding hospital cover. The Surcharge is an additional tax that can be avoided by taking out hospital cover.</p>
		<h3>Extras cover will not exempt you from the Medicare Levy Surcharge</h3>
		<p>You must ensure that you have hospital cover in order to be exempt from paying the surcharge, as extras cover is not enough.</p>
		<div style="height:10px;"><!-- empty --></div>
	</div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
#medicare-levy-surcharge-dialog {
	min-width:				637px;
	max-width:				637px;
	width:					637px;
	display: 				none;
	overflow:				hidden;
}
#medicare-levy-surcharge-dialog .clear{clear:both;}

#medicare-levy-surcharge-dialog .innertube {
	margin:					0 20px;
}

#medicare-levy-surcharge-dialog h3,
#medicare-levy-surcharge-dialog p {
	font-size:				14px;
}

#medicare-levy-surcharge-dialog h3 {
	font-weight:			900;
	margin:					15px 0 5px 0;
}

#medicare-levy-surcharge-dialog h3:first-child {
	margin-top:				0;
}

#medicare-levy-surcharge-dialog p {
	margin:					8px 0;
	font-size:				13px;
	line-height:			15px;
}

#medicare-levy-surcharge-dialog table {
	width:					96%;
}

#medicare-levy-surcharge-dialog .spacesaver {
	width:					50%;
	float:					left;
	margin-top:				10px;
}

#medicare-levy-surcharge-dialog .spacesaver.right {
	float:					right;
}

#medicare-levy-surcharge-dialog .innertube th,
#medicare-levy-surcharge-dialog .innertube td {
	padding:				5px 10px;
	border:					1px solid #E3E8EC;
	text-align:				left;
}

#medicare-levy-surcharge-dialog .innertube th {
	font-weight:			900;
}

#medicare-levy-surcharge-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
	width: 					637px;
	height: 				14px;
	clear: 					both;
}

.ui-dialog.medicare-levy-surcharge-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog.medicare-levy-surcharge-dialog .message-form, .ui-dialog #medicare-levy-surcharge-dialog{
	padding:				0;
}

.medicare-levy-surcharge-dialog .ui-dialog-titlebar {
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

.medicare-levy-surcharge-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_637.png") !important;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var MedicareLevySurchargeDialog = new Object();
MedicareLevySurchargeDialog = {

	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#medicare-levy-surcharge-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip', 
			'modal':true, 
			'width':637,
			'minWidth':637,
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'medicare-levy-surcharge-dialog',
			'title':'Find out more about the Medicare Levy Surcharge.',
			open: function() {
				MedicareLevySurchargeDialog.show(); 
				$('.ui-widget-overlay').bind('click', function () { $('#medicare-levy-surcharge-dialog').dialog('close'); });
			},
			close: function(){
				MedicareLevySurchargeDialog.hide();	
		  	}
		});	
	},
	
	launch: function() {
		$('#medicare-levy-surcharge-dialog').dialog("open");
	},
	
	hide: function() {
		$("#medicare-levy-surcharge-dialog").hide();
	},

	show: function() {
		$("#medicare-levy-surcharge-dialog").show();
		Track.onCustomPage("Medicare Levy Surcharge Dialog");
	}
};
</go:script>
<go:script marker="onready">
MedicareLevySurchargeDialog.init();
</go:script>