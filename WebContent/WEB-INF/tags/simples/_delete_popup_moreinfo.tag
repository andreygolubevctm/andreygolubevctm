<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Popup to view quote more info content."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- HTML --%>
<div id="quote-moreinfo-dialog" class="quote-moreinfo-dialog" title="More Info">
	<div class="wrapper">
		<table>
			<tr class="status">
				<th>Status:</th>
				<td></td>
			</tr>
			<tr class="transaction">
				<th>Transaction:</th>
				<td></td>
			</tr>
			<tr class="state">
				<th>State:</th>
				<td></td>
			</tr>
			<tr class="cover">
				<th>Cover Type:</th>
				<td></td>
			</tr>
			<tr class="primary">
				<th>Primary:</th>
				<td></td>
			</tr>
			<tr class="partner">
				<th>Partner:</th>
				<td></td>
			</tr>
			<tr class="phone">
				<th>Phone:</th>
				<td></td>
			</tr>
			<tr class="address">
				<th>Address:</th>
				<td></td>
			</tr>
			<tr class="benefits">
				<th>Benefits:</th>
				<td></td>
			</tr>
		</table>

		<hr />
		<h4>Latest activity:</h4>
		<div class="touches"></div>
	</div>
	<div class="dialog_footer"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#quote-moreinfo-dialog {
	min-width:				540px;
	max-width:				540px;
	width:					540px;
	display: 				none;
	overflow:				hidden;
}
#quote-moreinfo-dialog h2 {
	margin:					12px 3px;
}
#quote-moreinfo-dialog .wrapper {
	margin: 				0 15px 15px 15px;
}

#quote-moreinfo-dialog .wrapper table,
#quote-moreinfo-dialog .wrapper .touches .innertube,
#quote-moreinfo-dialog .wrapper .touches .row {
	width:					100%;
}

#quote-moreinfo-dialog .wrapper th {
	font-weight:			bold;
	text-align:				right;
	padding-right:			10px;
	width:					120px;
}

#quote-moreinfo-dialog .wrapper th,
#quote-moreinfo-dialog .wrapper td {
	padding-bottom:			5px;
}

#quote-moreinfo-dialog .wrapper .partner,
#quote-moreinfo-dialog .wrapper .phone,
#quote-moreinfo-dialog .wrapper .address,
#quote-moreinfo-dialog .wrapper .benefits {
	display: 				none;
}

#quote-moreinfo-dialog .wrapper .transaction span {
	font-size:				90%;
	font-style:				oblique
	margin-left:			10px;
}

#quote-moreinfo-dialog .wrapper .status p {
	font-weight: 			bold;
	font-size:				110%;
}
#quote-moreinfo-dialog .wrapper .status p.editableF {
	color: #E54200;<%-- orange --%>
}
#quote-moreinfo-dialog .wrapper .status p.editableC {
	color: #0CB24E;<%-- green --%>
}

#quote-moreinfo-dialog .wrapper .status p a {
	margin-left:			10px;
	float:					right !important;
}

#quote-moreinfo-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_540.gif") no-repeat scroll left top transparent;
	width: 					540px;
	height: 				14px;
	clear: 					both;
}

#search-quote-list .quote-latest-button {
	display:				none;
}

#quote-moreinfo-dialog .search-quotes #search-quote-list .quote-row .quote-amend-button span,
#quote-moreinfo-dialog .search-quotes #search-quote-list .quote-row .quote-moreinfo-button span {
	margin-top:				0;
}

.ui-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog .message-form, .ui-dialog #quote-moreinfo-dialog{
	padding:				0;
}

.quote-moreinfo-dialog .ui-dialog-titlebar {
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

.quote-moreinfo-dialog .ui-dialog-content {
	background-image:		url("common/images/dialog/content_540.gif") !important;
}

#quote-moreinfo-dialog .touches {
	margin-top: 0.5em;
}

#quote-moreinfo-dialog .touches .row {
	margin-bottom:			5px;
}

#quote-moreinfo-dialog .touches span {
	float: 					left;
	text-align: 			left;
	overflow:				hidden;
	padding-right:			10px;
}

#quote-moreinfo-dialog .wrapper .touches .row.title span {
	font-weight:			bold;
}

#quote-moreinfo-dialog .wrapper .touches .col1 {width:72px;}
#quote-moreinfo-dialog .wrapper .touches .col2 {width:120px;}
#quote-moreinfo-dialog .wrapper .touches .col3 {width:80px;}
#quote-moreinfo-dialog .wrapper .touches .col4 {width:180px;}

#quote-moreinfo-dialog .wrapper .touches .innertube {
	height:					13.75em;
	overflow:				auto;
	overflow-y:				auto;
	overflow-x:				none;
}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var MoreInfoDialog = {

	_data : null,

	init: function() {

		// Initialise the search quotes dialog box
		// =======================================
		$('#quote-moreinfo-dialog').dialog({
			autoOpen: false,
			show: {
				effect: 'clip',
				complete: function(){
					$(".ui-dialog.quote-moreinfo-dialog").first().center();
				}
			},
			hide: 'clip',
			position: 'center',
			'modal':true,
			'width':540,
			'minWidth':540,
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'quote-moreinfo-dialog',
			'title':'More Info',
			open: function() {
				MoreInfoDialog.show();
			},
			close: function(){
				MoreInfoDialog.hide();
			}
		});
	},

	launch: function( data ) {
		MoreInfoDialog._data = data;

		var q = MoreInfoDialog._data;

		var elements = {
			status : 		$("#quote-moreinfo-dialog .wrapper .status").first(),
			transaction : 	$("#quote-moreinfo-dialog .wrapper .transaction").first(),
			state : 		$("#quote-moreinfo-dialog .wrapper .state").first(),
			cover : 		$("#quote-moreinfo-dialog .wrapper .cover").first(),
			primary : 		$("#quote-moreinfo-dialog .wrapper .primary").first(),
			partner : 		$("#quote-moreinfo-dialog .wrapper .partner").first(),
			phone : 		$("#quote-moreinfo-dialog .wrapper .phone").first(),
			address : 		$("#quote-moreinfo-dialog .wrapper .address").first(),
			benefits : 		$("#quote-moreinfo-dialog .wrapper .benefits").first(),
			touches : 		$("#quote-moreinfo-dialog .wrapper .touches").first()
		}

		var link = "";
		if (q.available == 'no') {
			link = "<a href='health_confirmation.jsp?action=confirmation&amp;token=" + q.confirmationId + "' class='tinybtn' target='_blank' title='open quote&#39;s confirmation page'><span>View Confirmation</span></a>";
		}

		var status = "<p class='editable" + q.editable + "'>";
		if (q.editable == 'C') status += 'SOLD';
		else if (q.editable == 'F') status += 'PENDING/FAILED';
		else status += 'AVAILABLE';
		status += link + "</p>";
		elements.status.find("td").empty().append(status);

		elements.transaction.find("td").empty()
			.append("<p>" + q.id + (q.id != q.rootid ? "<span>[" + q.rootid + "]</span>" : "") + "</p>")
			.append("<p>" + q.quoteDate + " " + q.quoteTime + "</p>");

		elements.state.find("td").empty().append("<p>" + q.resultData.state + "</p>");

		elements.cover.find("td").empty().append("<p>" + q.resultData.situation + "</p>");

		elements.primary.find("td").empty();
		if (q.contacts.primary.name != '') {
			elements.primary.find("td").append("<p>" + q.contacts.primary.name + "</p>");
		}
		if (q.contacts.primary.dob != '') {
			elements.primary.find("td").append("<p>" + q.contacts.primary.dob + "</p>");
		}

		elements.partner.find("td").empty();
		if (q.contacts.partner.name != '') {
			elements.partner.find("td").append("<p>" + q.contacts.partner.name + "</p>");
		}
		if (q.contacts.partner.dob != '') {
			elements.partner.find("td").append("<p>" + q.contacts.partner.dob + "</p>");
		}
		if( elements.partner.find("td").is(":empty") ) {
			elements.partner.hide();
		} else {
			elements.partner.show();
		}

		elements.phone.find("td").empty();
		if (q.resultData.phone != '') {
			elements.phone.find("td").append("<p>" + q.resultData.phone + "</p>");
			elements.phone.show();
		} else {
			elements.phone.hide();
		}

		elements.address.find("td").empty();
		if (q.resultData.address != '' ) {
			elements.address.find("td").append("<p>" + q.resultData.address + "</p>");
		}
		if( elements.address.find("td").is(":empty") ) {
			elements.address.hide();
		} else {
			elements.address.show();
		}

		elements.benefits.find("td").empty();
		if (q.resultData.benefits != '' ) {
			elements.benefits.find("td").append("<p>" + q.resultData.benefits + "</p>");
			elements.benefits.show();
		} else {
			elements.benefits.hide();
		}

		elements.touches.empty();
		if (q.touches && q.touches.touch) {
			if (!$.isArray(q.touches.touch)) {
				q.touches.touch = [q.touches.touch];
			}
			elements.touches.append('<div class="row title"><span class="col1">Transaction</span><span class="col2">Date</span><span class="col3">Operator</span><span class="col4">Action</span><div class="clear" /></div><div class="innertube"></div>');
			for (var i=0; i < q.touches.touch.length; i++) {
				var t = q.touches.touch[i];
				elements.touches.find('div.innertube:first').append('<div class="row"><span class="col1">' + t.id + '</span><span class="col2">' + t.datetime + '</span><span class="col3">' + t.operator + '</span><span class="col4">' + t.type + '</span><div class="clear" /></div>');
			}
		}
		else {
			elements.touches.html('No activity found.');
		}

		$('#quote-moreinfo-dialog').dialog("open");
	},

	close: function() {
		$('#quote-moreinfo-dialog').dialog("close");
	},

	hide: function() {
		MoreInfoDialog._data = null;
		$("#quote-moreinfo-dialog").hide("fast");
	},

	show: function() {
		$("#quote-moreinfo-dialog").show("fast");
	},

	getNiceDate : function( dateString ) {

		var pattern = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/;
		var dateArray = pattern.exec(dateString);
		var dateObj = new Date(
				(+dateArray[1]),
				(+dateArray[2])-1,
				(+dateArray[3]),
				(+dateArray[4]),
				(+dateArray[5]),
				(+dateArray[6])
		);
		var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		var months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		var day = dateObj.getDate();
		var dayLabel = days[dateObj.getDay()];
		var day_suffix = "th";
		switch(day) {
			case 1:
				day_suffix = "st";
				break;
			case 2:
				day_suffix = "nd";
				break;
			case 3:
				day_suffix = "rd";
				break;
		}

		day += day_suffix;
		var month = months[dateObj.getMonth()];
		var year = dateObj.getFullYear();
		var hrs = dateObj.getHours();
		var mer = hrs >= 12 ? "pm" : "am";
		if( hrs == 0 ) {
			hrs = 12;
		} else if( hrs > 12 ) {
			hrs = hrs - 12;
		}
		var mins = dateObj.getMinutes();
		mins = mins < 10 ? "0" + mins : mins;

		return dayLabel + " " + day + " " + month + ", " + year + " at " + hrs + ":" + mins + mer;
	}
};
</go:script>
<go:script marker="onready">
MoreInfoDialog.init();
</go:script>