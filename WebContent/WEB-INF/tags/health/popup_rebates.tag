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

<%-- Include this tag to add required rebate multiplier variables to the request --%>
<health:changeover_rebates />

<%-- Format the range of rebates for use in various places - either a whole percent or the adjusted percent to 3 decimal places --%>
<c:set var="rebate_value_40" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${40 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>40</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_35" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${35 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>35</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_30" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${30 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>30</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_25" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${25 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>25</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_20" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${20 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>20</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_15" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${15 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>15</c:otherwise>
	</c:choose>
</c:set>

<c:set var="rebate_value_10" scope="request">
	<c:choose>
		<c:when test="${rebate_multiplier_current ne 1}">
			<fmt:formatNumber type="currency" value="${10 * rebate_multiplier_current}" minFractionDigits="3" groupingUsed="false" currencySymbol=""/>
		</c:when>
		<c:otherwise>10</c:otherwise>
	</c:choose>
</c:set>

<%-- HTML --%>
<div id="rebates-info-dialog" class="rebates-info-dialog" title="Search Health Quotes">
	<div class="innertube">
		<h3>What is the Australian Government Rebate?</h3>
		<p>The health insurance rebate exists to provide financial assistance to those who need help with the cost of their health insurance premium. It is currently means-tested and tiered according to taxable income and the age of the oldest person covered by the policy.</p>
		<p>Currently, if you take out private health insurance and Lifetime health cover loading has been applied to your premium and you meet the eligibility criteria for an Australian Government Rebate, you will receive the full rebate on the premium and the Lifetime health cover loading.</p>
		<p>However, as of 1 July, 2013 the Australian Government will remove the rebate on the Lifetime Health Cover loading, increasing the overall premium value for the average consumer and reducing the proportion covered by the rebate.</p>
		<h3>How does the Australian Government Rebate affect you?</h3>
		<p>The tiers below represent the current potential percentage rebate opportunity for singles, couples and families.</p>

		<h3>2013-2014 Health insurance rebate for singles</h3>
		<table>
			<thead>
				<tr>
					<th>Age</th>
					<th>Under $88,000</th>
					<th>$88,001-$102,000</th>
					<th>$102,001-$136,000</th>
					<th>Over $136,001</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Under 65</td>
					<td>${rebate_value_30}%</td>
					<td>${rebate_value_20}%</td>
					<td>${rebate_value_10}%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>65-69 years</td>
					<td>${rebate_value_35}%</td>
					<td>${rebate_value_25}%</td>
					<td>${rebate_value_15}%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>Over 70</td>
					<td>${rebate_value_40}%</td>
					<td>${rebate_value_30}%</td>
					<td>${rebate_value_20}%</td>
					<td>Nil</td>
				</tr>
			</tbody>
		</table>
		
		<h3>2013-2014 Health insurance rebate for couples and families</h3>
		<table>
			<thead>
				<tr>
					<th>Age</th>
					<th>Under $176,000</th>
					<th>$176,001-$204,000</th>
					<th>$204,001-$272,000</th>
					<th>Over $272,000</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Under 65</td>
					<td>${rebate_value_30}%</td>
					<td>${rebate_value_20}%</td>
					<td>${rebate_value_10}%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>65-69 years</td>
					<td>${rebate_value_35}%</td>
					<td>${rebate_value_25}%</td>
					<td>${rebate_value_15}%</td>
					<td>Nil</td>
				</tr>
				<tr>
					<td>Over 70</td>
					<td>${rebate_value_40}%</td>
					<td>${rebate_value_30}%</td>
					<td>${rebate_value_20}%</td>
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

		<h3>What is the Medicare Levy Surcharge?</h3>
		<p>The Medicare Levy Surcharge is an extra tax levied on higher income earners who don't hold hospital cover. The purpose of the Surcharge is to encourage more people to take out private health insurance and ease the burden on the public health care system.</p>

		<h3>How much is the Medicare Levy Surcharge?</h3>
		<p>The Medicare Levy Surcharge is dependent on your taxable income.</p>

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
					<td>Over $272,001</td>
					<td>1.50%</td>
				</tr>
			</tbody>
		</table>

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
#rebates-info-dialog {
	min-width:				637px;
	max-width:				637px;
	width:					637px;
	display: 				none;
	overflow:				hidden;
	overflow-y: 	scroll;
	position: static;
}
#rebates-info-dialog h2 {
	margin:24px 0px;
	font-size:1.5em;
}
#rebates-info-dialog h3 em {
	font-style:normal;
	color:#0CB24E;
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