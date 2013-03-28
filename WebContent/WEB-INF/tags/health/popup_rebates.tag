<%@ tag language="java" pageEncoding="ISO-8859-1"%>
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
<div id="rebates-info-dialog" class="rebates-info-dialog" title="Search Health Quotes">
	<div class="innertube">
		<h3>Australian Government Rebate</h3>
		<p>The health insurance rebate exists to provide financial assistance to those who need help with the cost of their health insurance premium. It is currently means-tested and tiered according to taxable income and the age of the oldest person covered by the policy.</p>
		<p>The health insurance rebate is available for both hospital and extras policies.</p> 
		<h3>Health insurance rebate for singles</h3>
		<table>
			<thead>
				<tr>
					<th>Age</th>
					<th>Under $84,000</th>
					<th>$84,001-$97,000</th>
					<th>$97,001-$130,000</th>
					<th>Over $130,000</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Under 65</td>
					<td>30.00%</td>
					<td>20.00%</td>
					<td>10.00%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>65-69 years</td>
					<td>35.00%</td>
					<td>25.00%</td>
					<td>15.00%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>Over 70</td>
					<td>40.00%</td>
					<td>30.00%</td>
					<td>20.00%</td>
					<td>Nil</td>
				</tr>
			</tbody>
		</table>
		
		<h3>Health insurance rebate for couples and families</h3>
		<table>
			<thead>
				<tr>
					<th>Age</th>
					<th>Under $168,000</th>
					<th>$168,001-$194,000</th>
					<th>$194,001-$260,000</th>
					<th>Over $260,000</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Under 65</td>
					<td>30.00%</td>
					<td>20.00%</td>
					<td>10.00%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>65-69 years</td>
					<td>35.00%</td>
					<td>25.00%</td>
					<td>15.00%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>Over 70</td>
					<td>40.00%</td>
					<td>30.00%</td>
					<td>20.00%</td>
					<td>Nil</td>
				</tr>
			</tbody>
		</table>
								
		<p>This includes single parent families.</p>
		<p>The income thresholds are adjusted for families with more than one child, being increased by $1,500 for every dependent child after the first.</p>
		<h3>Claiming the Health Insurance Rebate</h3>
		<p>The health insurance rebate can be claimed in one of three ways:</p>
		<ol>
			<li>1. Deduct the cost of the rebate directly from your health insurance premium.</li>
			<li>2. Claim the rebate on your tax return.</li>
			<li>3. Claim the rebate from your local Medicare office.</li>
		</ol>
		<p>The easiest and most popular method of claiming is to deduct the rebate directly from your health insurance premium, which is an option you can select on your health insurance policy application.</p>
		<p>If you claim a rebate and find at the end of the financial year that it was incorrect for whatever reason, the Australian Tax Office will simply correct the amount either overpaid or owing to you after your tax return has been completed. There is no penalty for making a rebate claim that turns out to have been incorrect.</p>

	</div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
#rebates-info-dialog {
	min-width:				637px;
	max-width:				637px;
	width:					637px;
	display: 				none;
	overflow:				hidden;
}
#rebates-info-dialog .clear{clear:both;}

#rebates-info-dialog .innertube {
	margin:					0 20px;
}

#rebates-info-dialog h3,
#rebates-info-dialog p {
	font-size:				14px;
}

#rebates-info-dialog h3 {
	font-weight:			900;
	margin:					15px 0 5px 0;
}

#rebates-info-dialog h3:first-child {
	margin-top:				0;
}

#rebates-info-dialog p {
	margin:					8px 0;
	font-size:				13px;
	line-height:			15px;
}

#rebates-info-dialog .innertube th,
#rebates-info-dialog .innertube td {
	padding:				5px 10px;
	border:					1px solid #E3E8EC;
	text-align:				left;
}

#rebates-info-dialog .innertube th {
	font-weight:			900;
}

#rebates-info-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
	width: 					637px;
	height: 				14px;
	clear: 					both;
}

.ui-dialog.rebates-info-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog.rebates-info-dialog .message-form, .ui-dialog #rebates-info-dialog{
	padding:				0;
}

.rebates-info-dialog .ui-dialog-titlebar {
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

.rebates-info-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_637.png") !important;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var RebatesInfoDialog = new Object();
RebatesInfoDialog = {

	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#rebates-info-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip', 
			'modal':true, 
			'width':637, 'height':715, 
			'minWidth':637, 'minHeight':715,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'rebates-info-dialog',
			'title':'Information about the Government Rebate',
			open: function() {
				RebatesInfoDialog.show(); 
				$('.ui-widget-overlay').bind('click', function () { $("#rebates-info-dialog").dialog('close'); });
			},
			close: function(){
				RebatesInfoDialog.hide();	
		  	}
		});	
	},
	
	launch: function() {
		$('#rebates-info-dialog').dialog("open");
	},
	
	hide: function() {
		$("#rebates-info-dialog").hide();
	},

	show: function() {
		$("#rebates-info-dialog").show();
		Track.onCustomPage("Rebates Info Dialog");
	}
};
</go:script>
<go:script marker="onready">
RebatesInfoDialog.init();
</go:script>