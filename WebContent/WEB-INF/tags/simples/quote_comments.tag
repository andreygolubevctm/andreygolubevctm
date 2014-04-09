<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="quote-comments-dialog" class="quote-comments-dialog" title="Search Health Quotes">
	<div class="wrapper">
		<div id="comment-options-bar">
			<a href="javascript:void(0);" id="quote-comments-option-show-add" title="Add comment to this quote">Add Comment</a>
			<a href="javascript:void(0);" id="quote-comments-option-show-change" title="Load comments for a different quote">Change Quote</a>
			<div class="clear"><!-- empty --></div>
		</div>
		<div id="change-quote-bar" class="bar-content">
			<label for="quote-comments-change-transactionid">Quote Id</label>
			<input type="text" name="quote-comments-change-transactionid" id="quote-comments-change-transactionid" />
			<button id="quote-comments-change-submit">Change Quote</button>
		</div>
		<div id="new-comment-bar" class="bar-content">
			<label for="quote-comments-transactionid">Quote Id:</label>
			<input type="text" name="quote-comments-add-transactionid" id="quote-comments-add-transactionid" />
			<label for="quote-comments-comment" class="comment-label">Add Comment:</label>
			<textarea name="quote-comments-comment" id="quote-comments-comment">Some comment goes here...</textarea>
			<button id="quote-comments-add-submit">Add Comment</button>
			<div class="clear"><!-- empty --></div>
		</div>
		<div class="quote-comments">
			<div class="header"><div>Reference:</div><div id="quote-transactionid" class="ref"><!-- empty --></div></div>
			<div id="quote-comments-list" class="content"><!-- empty --></div>
			<div id="quote-comments-list-empty" class="content">
				<p>No comments found to display...</p>
			</div>
			<div class="footer"><!-- empty --></div>
		</div>
	</div>
	<div class="dialog_footer"></div>
</div>
				
<core:js_template id="quote-comment">
	<div class="quote-comment" id="quote-comment-[#=commId#]" style="display: block; ">
		<div class="title">
			<span class="date">[#=createDate#]</span>
			<span class="time">[#=createTime#]</span>
			<span class="operator">[#=operatorId#]</span>
			<div class="clear"><!-- empty --></div>
		</div>
		<div class="comment">
			<p class="comment">[#=comment#]</p>
		</div>
	</div>
</core:js_template>


<%-- CSS --%>
<go:style marker="css-head">
#quote-comments-dialog {
	min-width:				637px;
	max-width:				637px;
	width:					637px;
	display: 				none;
	overflow:				hidden;
}
#quote-comments-dialog .clear{clear:both;}
#quote-comments-dialog h2 {
	margin:					12px 3px;
}
#quote-comments-dialog label {
	font-weight:			bold;
}
#quote-comments-dialog label.comment-label {
	display:				block;
	margin-top:				5px;
}
#quote-comments-dialog input {
	padding-left:			5px;
	padding-right:			5px;
}
#quote-comments-dialog textarea {
	width:					602px;
	height:					75px;
}
#quote-comments-dialog input,
#quote-comments-dialog textarea {
	border:					1px solid #A0A0A0;
}
#quote-comments-dialog .bar-content {
	display:				none;
}
#quote-comments-dialog .bar-content,
#quote-comments-dialog #comment-options-bar {
	margin-bottom:			10px;
}
#quote-comments-dialog #new-comment-bar span {
	font-weight:			bold;
	color:					#A0A0A0;
}
#quote-comments-dialog #new-comment-bar button {
	float:					right;
}
#quote-comments-dialog #comment-options-bar a {
	float:					right;
	color:					#0CB24E;
	font-weight:			bold;
	margin-left:			10px;
}
#quote-comments-dialog #comment-options-bar a:hover {
	color:					#0C4DA2;
}
#quote-comments-dialog #comment-options-bar a.active {
	text-decoration:		none;
	color:					#0C4DA2;
}
#quote-comments-dialog .wrapper {
	margin: 				0 15px;
}

#quote-comments-dialog .quote-comments {
	width:					607px;
}
#quote-comments-dialog .error {
	border-color:			red;
}
#quote-comments-dialog .quote-comments .header{
    background: 			transparent url("brand/ctm/images/main_bg_607_top.png") top left no-repeat;
    color: 					#0C4DA2;
    font-family: 			"SunLT Bold","Open Sans",Helvetica,Arial,sans-serif;
    font-size: 				16px;
    font-weight: 			bold;
    height: 				20px;
    padding: 				10px 14px 4px 14px;
    position: 				relative;
}
#quote-comments-dialog .quote-comments .header div{
	float:					left;
}
#quote-comments-dialog .quote-comments .header div.ref{
	float:					left;
    color: 					#0CB24E;
    font-weight:			900;
    margin-left:			10px;
}

#quote-comments-dialog .quote-comments .footer {
	background-image: 		url(brand/ctm/images/main_bg_607_bottom.png);
	background-repeat: 		no-repeat;
	height: 				19px;
}

#quote-comments-dialog .quote-comments .content {
	overflow: 				auto;
    background: 			white;
	padding: 				10px 14px;
	border-left: 			1px solid #E3E8EC;
	border-right: 			1px solid #E3E8EC;
	font-size: 				12px;
	display:				none;
}
#quote-comments-dialog .quote-comments #quote-comments-list {
	height: 				411px;
}
#quote-comments-dialog .quote-comments .content .quote-comment {
	border-bottom: 			1px solid #E3E8EC;
	padding: 				5px 0;
}
#quote-comments-dialog .quote-comments .quote-comment .title{
	font-weight:			bold;
	margin:					10px 0 5px 0;
}
#quote-comments-dialog .quote-comments .quote-comment .title span{
	float: 					left;
	font-weight:			bold;
	margin-right:			10px;
}
#quote-comments-dialog .quote-comments .quote-comment .title span.operator{
	float: 					right;
	margin:					0;
}
#quote-comments-dialog .quote-comments .quote-comment .comment{
	margin-bottom:			5px;
}

#quote-comments-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
	width: 					637px;
	height: 				14px;
	clear: 					both;
}

.ui-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog .message-form, .ui-dialog #quote-comments-dialog{
	padding:				0;
}

.quote-comments-dialog .ui-dialog-titlebar {
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

.quote-comments-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_637.png") !important;
}

#quote-comments-error .content,
#quote-add-comments-error .content {
	padding-left:			2em;
	padding-right:			2em;
}

#quote-comments-error-message,
#quote-add-comments-error-message {
	padding-top:			10px;
	padding-bottom:			10px;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var QuoteComments = new Object();
QuoteComments = {

	_transactionid: null,
	
	_comments: [],
	
	_default_comment: "Add comment text here...",
	
	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#quote-comments-dialog').dialog({
			autoOpen: false,
			show: {
				effect: 'clip',
				complete: function(){
					$(".ui-dialog.quote-comments-dialog").first().center();
				}
			},
			hide: 'clip', 
			position: 'center',
			'modal':true, 
			'width':637, 'height':580, 
			'minWidth':637, 'minHeight':580,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'quote-comments-dialog',
			'title':'Quote Comments',
			open: function() {
				QuoteComments.getComments();
			},
			close: function(){
				QuoteComments.closeOptions();	
		  	}
		});	
		
		$("#quote-comments-comment").val(QuoteComments._default_comment);
		
		$("#quote-comments-option-show-add").on("click", QuoteComments.toggleAddForm);
		$("#quote-comments-option-show-change").on("click", QuoteComments.toggleChangeForm);
		
		// Error popup close button listeners
		// ==================================
		$("#quote-add-comments-error .close-error").first().on("click", function(){
			Popup.hide("#quote-add-comments-error");
		});
		
		$("#quote-comments-error .close-error").first().on("click", function(){
			Popup.hide("#quote-comments-error");
		});
		
		// Add listeners for change quote form
		$("#quote-comments-change-submit").on("click", QuoteComments.changeQuote);		
		$("#quote-comments-change-transactionid").on("keypress", function(e){
			if( e.which == 13 ) {
				QuoteComments.changeQuote();
			}
		});
		
		// Add listeners for add comment form
		$("#quote-comments-add-submit").on("click", QuoteComments.addComment);		
		$("#quote-comments-add-transactionid").on("keypress", function(e){
			if( e.which == 13 ) {
				QuoteComments.addComment();
			}
		});
		
		$("#quote-comments-comment").on("focus", function(){
			if( $(this).val() == QuoteComments._default_comment ) {
				$(this).val("");
			}
		});
		
		$("#quote-comments-comment").on("blur", function(){
			if( $(this).val().length < 10 ) {
				$(this).val(QuoteComments._default_comment);
			}
		});
	},
	
	closeOptions: function() {
		QuoteComments.resetChangeForm();
		QuoteComments.resetAddForm();
	},
	
	toggleAddForm: function() {
		if($("#new-comment-bar").is(":visible"))
		{
			$("#quote-comments-option-show-change").removeClass("active");
			$("#quote-comments-option-show-add").removeClass("active");
			$("#new-comment-bar").hide("fast", QuoteComments.setCommentsListHeight);
		}
		else
		{
			$("#change-quote-bar").hide("fast", function(){
				$("#quote-comments-option-show-change").removeClass("active");
				$("#quote-comments-option-show-add").addClass("active");
				QuoteComments.setCommentsListHeight("small");
				$("#quote-comments-comment").focus();
			});
		}
	},
	
	resetAddForm: function( callback ) {
	
		callback = callback || false;
		
		$("#quote-comments-comment").val( QuoteComments._default_comment);
		
		if($("#new-comment-bar").is(":visible"))
		{
			QuoteComments.toggleAddForm();
		}
			
		if( typeof(callback) == "function" )
		{
			callback();
		}
	},
	
	toggleChangeForm: function() {
		if($("#change-quote-bar").is(":visible"))
		{
			$("#quote-comments-option-show-change").removeClass("active");
			$("#quote-comments-option-show-add").removeClass("active");
			$("#change-quote-bar").hide("fast", QuoteComments.setCommentsListHeight);
		}
		else
		{
			$("#new-comment-bar").hide("fast", function(){
				$("#quote-comments-option-show-add").removeClass("active");
				$("#quote-comments-option-show-change").addClass("active");
				QuoteComments.setCommentsListHeight("medium");
				$("#quote-comments-change-transactionid").focus();
			});
		}
	},
	
	resetChangeForm: function( callback ) {
	
		callback = callback || false;
		
		$("#quote-comments-change-transactionid").val("");	
		
		if( QuoteComments._transactionid ) {
		if($("#change-quote-bar").is(":visible"))
		{
			QuoteComments.toggleChangeForm();
		}
		} else {
			$('#quote-transactionid').text('None');
			$("#quote-comments-option-show-add").removeClass("active");
			$("#quote-comments-option-show-change").addClass("active");
			QuoteComments.setCommentsListHeight("medium");
			$("#quote-comments-change-transactionid").focus();
		}
			
		if( typeof(callback) == "function" )
		{
			callback();
		}
	},
	
	setCommentsListHeight: function(size) {
		switch(size) 
		{
			case "small":
				$("#quote-comments-list").animate({height:261},"fast", function(){
					$("#new-comment-bar").show("fast");
				});
				break;
			case "medium":
				$("#quote-comments-list").animate({height:376},"fast", function(){
					$("#change-quote-bar").show("fast");
				});
				break;
			default:
				$("#quote-comments-list").animate({height:411},"fast");
				break;
		}
	},

	fixOverlays : function() {		
		// Bug fix the overlay
		if( $('.ui-dialog.quote-comments-dialog').last().is(':visible') ) {
			src_zindex = Number($('.ui-dialog.quote-comments-dialog').last().css('z-index'));
			$('.ui-widget-overlay').last().css({zIndex:--src_zindex});
		}
	},

	show: function( tranid ) {
	
		tranid = tranid || false;
		
		if( tranid ) {
			QuoteComments._transactionid = tranid;
		}
		
			if($("#quote-comments-dialog").dialog( "isOpen" ))
			{
				QuoteComments.getComments();
			}
			else
			{
				$('#quote-comments-dialog').dialog("open");
			}
	},
	
	changeQuote: function() {
		var tranId = $("#quote-comments-change-transactionid").val().replace(/\D+/g, '');
		if( tranId.length )
		{
			$("#quote-comments-change-transactionid").removeClass("error");
			QuoteComments._transactionid = tranId;
			QuoteComments.getComments();
		}
		else
		{
			$("#quote-comments-change-transactionid").addClass("error");
			return;
		}
	},
	
	isValidComment: function( tranid, comment ) {
	
		var passed = true;
		
		if( tranid.length )
		{
			$("#quote-comments-add-transactionid").removeClass("error");
		}
		else
		{
			passed = false;
			$("#quote-comments-add-transactionid").addClass("error");
		}
		
		if( comment.length > 10 && comment != QuoteComments._default_comment )
		{
			$("#quote-comments-comment").removeClass("error");
		}
		else
		{
			passed = false;
			$("#quote-comments-comment").addClass("error");
		}
		
		return passed;
		
	},
	
	forceLogin: function() {
		document.location.href = "simples.jsp?r=" + Math.floor(Math.random()*10001);
	},

	handleErrors : function( errors, type, default_text ) {
		default_text = default_text || "Apologies: There was a fatal error.";
		var message = "";
		var force_login = false;
		try {
			for(var i in errors) {
				if( errors.hasOwnProperty(i) ) {
					if( errors[i].error == "login" ) {
						force_login = true;
					} else {
						message += "<p>" + errors[i].error + "</p>";
					}
				}
			}
		} catch(e) {
			message = "<p>" + default_text + "</p>";
		}
		if( force_login ) {
			QuoteComments.forceLogin();
		} else {
			switch(type) {
				case 'add':
					$("#quote-add-comments-error-message").empty().append(message);
					Popup.show("#quote-add-comments-error", "#loading-overlay");
					break;
				case 'get':
					$('#quote-comments-dialog').dialog("close");
					$("#quote-comments-error-message").empty().append(message);
					Popup.show("#quote-comments-error", "#loading-overlay");
					break;
				case 'load':
				default:
					break;
			}
		}
	},

	addComment: function() {
	
		var tranid = $("#quote-comments-add-transactionid").val().replace(/\D+/g, '');
		var comment = $("#quote-comments-comment").val().replace(/^\s+|\s+$/g, '');
	
		var error_text = "Apologies: There was a fatal error adding your comment.";

		if( QuoteComments.isValidComment(tranid, comment) )
		{
			QuoteComments.loading("Simples is adding your comment.");
			$.ajax({
				type: 		'GET',
				async: 		false,
				cache: 		false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				timeout: 	30000,			   
				url: 		"ajax/json/comments_add.jsp",
				data:		{transactionid:tranid, comment:comment},
				dataType: 	"json",
				error: 		function(data){
					Popup.hide("#simples-processing");
					$("#quote-comments-list").hide();
					$("#quote-comments-list-empty").show();
					try {
						errors = JSON.parse(data.responseText).errors;
					} catch(e) {
						errors = [{error:error_text}];
					}
					QuoteComments.handleErrors( errors, 'add', error_text );
				},
				success: 	function(json){
					Popup.hide("#simples-processing");
					try {
					QuoteComments._transactionid = json.sqlresponse.transactionId;
					QuoteComments._comments = json.sqlresponse.comments;
					QuoteComments.resetAddForm( QuoteComments.display );
					QuoteComments.fixOverlays();
					} catch(e) {
						if( json.hasOwnProperty('errors') ) {
							QuoteComments.handleErrors(json.errors, 'add', error_text);
						} else {
							QuoteComments.handleErrors( [{error:error_text}], 'add', error_text );
				}		   
					}
				}
		   });
		}
	},
	
	getComments: function()
	{
		var loading_msg = "Simples is loading the comments panel.";
		
		if( QuoteComments._transactionid ) {
			loading_msg = "Simples is loading comments for: " + QuoteComments._transactionid;
		}
		
		var error_text = "Apologies: There was a fatal error retrieving comments.";

		QuoteComments.loading(loading_msg);
			
		$.ajax({
			type: 		'GET',
			async: 		false,
			cache: 		false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				var label = "uncache",
				url = url.replace("?_=","?" + label + "=");
				url = url.replace("&_=","&" + label + "=");
				setting.url = url;
			},
			timeout: 	30000,			   
			url: 		"ajax/json/comments_get.jsp",
			data:		QuoteComments._transactionid == null ? {} : {transactionid:QuoteComments._transactionid},
			dataType: 	"json",
			error: 		function(data){
				Popup.hide("#simples-processing");
				$("#quote-comments-list").empty().hide();
				$("#quote-comments-list-empty").show();
				QuoteComments.toggleQuoteId();
				if( !$("#change-quote-bar").is(":visible") )
				{
					QuoteComments.toggleChangeForm();
				}
				try {
					errors = JSON.parse(data.responseText).errors;
				} catch(e) {
					errors = [{error:error_text}];
				}
				QuoteComments.handleErrors( errors, 'get', error_text );
			},
			success: 	function(json){
				Popup.hide("#simples-processing");
				try {
				QuoteComments._transactionid = json.sqlresponse.transactionId;
				QuoteComments._comments = json.sqlresponse.comments;
				QuoteComments.resetChangeForm( QuoteComments.display );
				QuoteComments.fixOverlays();
				} catch(e) {
					if( json.hasOwnProperty('errors') ) {
						QuoteComments.handleErrors(json.errors, 'get', error_text);
					} else {
						QuoteComments.handleErrors( [{error:error_text}], 'get', error_text );
			}		   
				}
			}
	   });
	},
	
	toggleQuoteId: function() {
		$("#quote-transactionid").empty().append(QuoteComments._transactionid == null ? "???" : QuoteComments._transactionid);
		$("#quote-comments-add-transactionid").val(QuoteComments._transactionid == null ? "" : QuoteComments._transactionid);
	},
	
	display: function( callback ) {
	
		callback = callback || false;
		
		QuoteComments.toggleQuoteId();
		
		var templateHtml = $("#quote-comment").html();
		
		$("#quote-comments-list").empty();
		
		var commentCount = 0;					
		if (typeof(QuoteComments._comments)!='undefined' && QuoteComments._comments instanceof Array)
		{
			$.each(QuoteComments._comments, function() {		
				if (QuoteComments._drawComment(this,templateHtml))
				{
					commentCount++;
				}
			});
		}
		else if(typeof(QuoteComments._comments)=='object' && !jQuery.isEmptyObject(QuoteComments._comments) && QuoteComments._comments.hasOwnProperty("commId"))
		{
			QuoteComments._drawComment(QuoteComments._comments,templateHtml)
			commentCount = 1;
		}

		if (commentCount > 0)
		{
			$("#quote-comments-list-empty").hide();
			
			var delay = 400;
			$(".quote-comment").each(function(){
				$(this).hide().delay(delay).fadeIn(200);
				delay+=100;
			});
			
			$("#quote-comments-list").show("fast");
		}
		else
		{
			$("#quote-comments-list").hide();	
			$("#quote-comments-list-empty").show();			
		}
			
		if( typeof(callback) == "function" )
		{
			callback();
		}
	},
	
	_drawComment : function(comment, templateHtml){
		comment.createDate = comment.createDate.replace(/-/g, "/");
		
		var newRow = $(parseTemplate(templateHtml, comment));
		var t = $(newRow).text();
		if (t.indexOf("ERROR") == -1) {
			$("#quote-comments-list").append(newRow);
			return true;
		}

		return false;
	},
	
	loading : function(message){
		$("#simples-processing-message").empty().append("<p>" + message + "</p>");
		Popup.show("#simples-processing", "#loading-overlay");
		}
};
</go:script>
<go:script marker="onready">
QuoteComments.init();
</go:script>