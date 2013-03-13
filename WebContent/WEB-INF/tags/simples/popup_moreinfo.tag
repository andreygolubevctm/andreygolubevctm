<%@ tag language="java" pageEncoding="ISO-8859-1"%>
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
	</div>
	<div class="dialog_footer"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
#quote-moreinfo-dialog {
	min-width:				400px;
	max-width:				400px;
	width:					400px;
	display: 				none;
	overflow:				hidden;
}
#quote-moreinfo-dialog h2 {
	margin:					12px 3px;
}
#quote-moreinfo-dialog .wrapper {
	margin: 				0 15px 15px 15px;
}

#quote-moreinfo-dialog .wrapper table {
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

#quote-moreinfo-dialog .wrapper .status p.status0 {
	color:					#E54200;
}

#quote-moreinfo-dialog .wrapper .status p.status1 {
	color:					#0CB24E;
}

#quote-moreinfo-dialog .wrapper .status p a {
	margin-left:			10px;
	float:					right !important;
}

#quote-moreinfo-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_400.gif") no-repeat scroll left top transparent;
	width: 					400px;
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
	background-image:		url("common/images/dialog/header_400.gif") !important;
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
	background-image:		url("common/images/dialog/content_400.gif") !important;
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
			'width':400, 
			'minWidth':400,  
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
			benefits : 		$("#quote-moreinfo-dialog .wrapper .benefits").first()
		}
		
		var link = "";
		if( !Number(q.editable) ) {
			link = "<a href='health_quote.jsp?action=confirmation&ConfirmationID=" + q.confirmationId + "' class='tinybtn' target='_blank' title='open quote&#39;s confirmation page'><span>View Confirmation</span></a>";
		}
		
		elements.status.find("td").empty().append("<p class='status" + q.editable + "'>" + (!Number(q.editable) ? "SOLD" : "Available") + link + "</p>");
		
		elements.transaction.find("td").empty()
			.append("<p>" + q.id + (q.id != q.rootid ? "<span>[" + q.rootid + "]</span>" : "") + "</p>")
			.append("<p>" + MoreInfoDialog.getNiceDate(q.startDate + " " + q.startTime) + "</p>");
			
		elements.state.find("td").empty().append("<p>" + q.state + "</p>");
		
		elements.cover.find("td").empty().append("<p>" + q.cover + "</p>");
		
		elements.primary.find("td").empty();
		if( q.primaryName != '' ) {
			elements.primary.find("td").append("<p>" + q.primaryName + "</p>");
		}
		if( q.primaryDOB != '' ) {
			elements.primary.find("td").append("<p>" + q.primaryDOB + "</p>");
		}
		
		elements.partner.find("td").empty();
		if( q.partnerName != '' ) {
			elements.partner.find("td").append("<p>" + q.partnerName + "</p>");
		}
		if( q.partnerDOB != '' ) {
			elements.partner.find("td").append("<p>" + q.partnerDOB + "</p>");
		}
		if( elements.partner.find("td").is(":empty") ) {
			elements.partner.hide();
		} else {
			elements.partner.show();
		}
		
		elements.phone.find("td").empty();
		if( q.phone != '' ) {
			elements.phone.find("td").append("<p>" + q.phone + "</p>");
			elements.phone.show();
		} else {
			elements.phone.hide();
		}
		
		elements.address.find("td").empty();
		if( q.address1 != '' ) {
			elements.address.find("td").append("<p>" + q.address1 + "</p>");
		}
		if( q.address2 != '' ) {
			elements.address.find("td").append("<p>" + q.address2 + "</p>");
		}
		if( elements.address.find("td").is(":empty") ) {
			elements.address.hide();
		} else {
			elements.address.show();
		}
		
		elements.benefits.find("td").empty();
		if( q.benefits != '' ) {
			elements.benefits.find("td").append("<p>" + q.benefits.split(",").join(", ") + "</p>");
			elements.benefits.show();
		} else {
			elements.benefits.hide();
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