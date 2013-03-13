<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Group for Vehicle Selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="title" 		required="false"  rtexprvalue="true"	 description="title of the select box" %>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="comms-messages ${className}" title="Call-backs">
	<div class="link comms-messages-next">Get Next in Queue</div>
	<div class="link comms-messages-new">Create New Call-back</div>
	<div id="${name}_messages"></div>
	<div class="dialog_footer"></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">
.comms-messages {
	min-width:380px;
	max-width:637px;
	width:637px;
}
.comms-messages h2 {
	margin:12px 3px;
}
.comms-messages div.link {
	width:auto;
	min-width:100px;
}
.comms-messages-next, .comms-messages-new  {
	margin:12px 6px;
	padding:8px 16px;
	background-color:#818181;
	border:1px solid #222;
	width:auto;
	color:#fff;
	display:inline-block;
	cursor:pointer;
}
.comms-messages-new {
	float:right;
}
.comms-messages .message-entries {
	padding:0px 12px;
	margin:6px;
	position:relative;
}
.comms-messages .message-entries .details {
	margin-top:12px;
	margin-bottom:12px;
	font-weight:bold;
	list-style:none;
	overflow:auto;
	padding-right:20px;
}
.comms-messages .message-entries .details li {
	float:left;
	margin-right:10px;
}
.comms-messages .message-entries .details .reason  {
	clear:left;
}
.comms-messages .message-entries .details span.state {
	display:inline-block;
	padding-right:18px;
	margin-right:17px;
	border-right:1px solid #ddd;
}
.comms-messages .message-entries .details .callback {
	float:right;
}
.comms-messages .message-entries .text {
	overflow:hidden;
	text-overflow:ellipsis;
	white-space:nowrap;
	clear:both;
	margin:10px 0px;
	
}
.comms-messages .message-entries .title {
	font-weight:bold;
	padding-top:6px;
	padding-bottom:6px;
	background-color:#CFD4D6;
	margin-left:-12px;
	margin-right:-12px;
	padding-left:12px;
	cursor:pointer;
}
.comms-messages .quick_assign {
	position:absolute;
	right:10px;
	top:0px;
}
	.ui-dialog .message-form, .ui-dialog .comms-messages{
		padding:0;
	}
	.message-form .save, .message-form .complete {
		margin:24px;
	}
	.message-form .save {
		float:right;
	}
	.fieldrow.messageRow .fieldrow_label {
		text-align:left;
		text-indent:31px;
	}
	.message-form select.state, .message-form select.queue {
		min-width:100px;
	}
	.message-form input.time {
		width:50px;
		min-width:50px;
	}
	.message-form input.datePicker {
		width:100px;
		min-width:100px;
	}
	.message-form .field.readonly {
		font-size:14px;
		color:#888;
		padding-top:9px;
		padding-bottom:9px;
	}	
	.message-form textarea.text {
		min-width:565px;
		min-height:100px;
		margin:10px 20px;
	}
	.message-form .titleRow.readonly {
		display:none;
	}
	.message-form .callbackRow .array_select {
		margin-left:10px;
	}
	.message-form.edit .callbackRow .basic_date,
	.message-form.edit .callbackRow .time {
		display:none;
		float:left;	
	}	
	.message-form.edit .callbackRow .time {
		margin-right:20px;
	}
	.message-form .callbackRow .lastItems {
		clear:both;
		min-height:40px;
	}
	.message-form.edit .callbackRow .rescheduleRow {
		padding:5px 0px;
		float:left;
	}
		.message-form.edit .callbackRow .rescheduleRow input {
			margin-left:0;
		}
	
	.message-form .timeLast, .message-form .dateLast {
	    float: left;
   		margin-right: 10px;
	}
	.message-form .usersRow {
		display:none;
	}
	.message-form.supervisor .usersRow {
		display:block;
	}
	.message-form .reschedule {
		margin-left:20px;
	}
	#message-form0 {
		display:none;
	}
	.message-form .dialog_footer, .comms-messages .dialog_footer {
		background: url("common/images/dialog/footer.gif") no-repeat scroll left top transparent;
		width: 637px; height: 14px;
		clear:both;
	}
	.comms-messages .dialog_footer {
		position:absolute;
		left:0;
		bottom:0;
	}
</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var commsMessages = new Object();
commsMessages = {
	update: function() {	
	   //calling the ajax form with the SQL
	   $.ajax({
		   type: 'GET',
	       async: false,
	       timeout: 30000,			   
		   url: "ajax/load/message_entries.jsp",
		   dataType: "html",
		   async: false,
		   cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
		   error: function(){ FatalErrorDialog.display('Apologies: There was an error getting the messages') },
		   success: function(data){
			   if(data != undefined) {
			   		commsMessages.display(data);
			   };
		   }		   
	   });
	},
	display: function(data) {
		$('#messages .link').button();
				
		$('#${name}_messages').html(data);
		//will need to bind all the messages again
		$('#${name}_messages').find('.message-entries').click( function() {
			var _id = $(this).attr('data-id');
			commsMessages.formbox( $('#message-form' + _id) );
		});
	},
	formbox: function(obj){
		$(obj).dialog({ width:637, modal: true } );
		<%-- Functions --%>
		$(obj).find('.save').button().click( function() {
			commsMessages.save(obj);
		});
		$(obj).find('.complete').button().click( function() {
			commsMessages.complete(obj);
		});		
	},
	save: function(obj){
	   //calling the ajax to save the form
	   var dat = $(obj).find('input,select,textarea').serialize();
	   $.ajax({
		   type: 'POST',
	       async: false,
	       timeout: 30000,			   
		   url: "ajax/write/comms_update_message.jsp",
		   dataType: "json",
		   data: dat,
		   async: false,
		   cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
		   error: function(){ FatalErrorDialog.display('Apologies: There was an error saving your call-back', dat) },
		   success: function(data){
			   if(data != undefined && data.status == 'OK') {
			   		$(obj).dialog('close');
			   		commsMessages.update();
			   } else {
			   		FatalErrorDialog.display('error: ' + data.error, dat);
			   };
		   }		   
	   });		
	},
	complete: function(obj){
	   //calling the ajax to complete the form	  
	   var dat = $(obj).find('input').serialize(); 
	   $.ajax({
		   type: 'POST',
	       async: false,
	       timeout: 30000,			   
		   url: "ajax/write/comms_completed.jsp",
		   dataType: "json",
		   data: dat,
		   async: false,
		   cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
		   error: function(){ FatalErrorDialog.display('Apologies: There was an error completing the call-back', dat) },
		   success: function(data){
			   if(data != undefined && data.status == 'OK') {
			   		$(obj).dialog('close');
			   		commsMessages.update();
			   } else {
			   		FatalErrorDialog.display('error: ' + data.error, dat);
			   };
		   }		   
	   });		
	}	
};
</go:script>
<go:script marker="onready">
	commsMessages.update();
	$('.comms-messages-new, #comms-menuBar li.new.message').click( function() {
		commsMessages.formbox( $('#message-form0') );
	});
	$('.comms-messages-next').click( function() {
		FatalErrorDialog.display('Feature alert: get the next call-back');
	});		
</go:script>
<simples:message_form xpath="messages" commsId="0" title="Create New Call-back"/>