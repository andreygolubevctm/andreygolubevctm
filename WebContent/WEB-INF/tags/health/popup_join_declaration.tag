<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<div id="join-declaration-dialog" class="join-declaration-dialog" title="Join Declaration">
	<div class="dialog_header"><!-- empty --></div>
	<div class="wrapper"></div>
	<div class="dialog_footer"><!-- empty --></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">

#join-declaration-dialog {
	min-width:				540px;
	max-width:				540px;
	width:					540px;
	display: 				none;
	overflow:				hidden;
	padding:				0 !important;
}

#join-declaration-dialog a {
	font-size:100%;
}

#join-declaration-dialog .clear{clear:both;}

#join-declaration-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_540.gif") no-repeat scroll left top transparent;
	width: 					540px;
	height: 				10px;
	clear: 					both;
}

#join-declaration-dialog .dialog_header {
	position:				absolute;
	left:					0;
	top:					0;
	background: 			url("brand/ctm/images/ui-dialog-header_540_under.gif") no-repeat scroll left bottom transparent;
	width: 					540px;
	height: 				10px;
	clear: 					both;
}

.ui-dialog.join-declaration-dialog .ui-dialog-titlebar {
	padding: 				0 !important;
	height: 				25px !important;
}

.ui-dialog.join-declaration-dialog .ui-dialog-titlebar .ui-dialog-title {
	display: 				none !important;
}

.ui-dialog.join-declaration-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					15px !important;
	right: 					1em;
}

.join-declaration-dialog .ui-dialog-titlebar {
	background-image:		url("brand/ctm/images/ui-dialog-header_540_over.gif") !important;
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

.join-declaration-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_540.png") !important;
}

.join-declaration-dialog .ui-dialog-content .wrapper {
	padding:					15px 20px;
}

.join-declaration-dialog .ui-dialog-content .wrapper p,
.join-declaration-dialog .ui-dialog-content .wrapper li {
	font-size:					10pt;
	line-height:				15px;
	padding:					3px 0;
}

.join-declaration-dialog .ui-dialog-content .wrapper li {
	list-style-type:			disc;
	padding-left:				5px;
	margin-left:				15px;
}

.join-declaration-dialog .ui-dialog-content .wrapper .button-wrapper {
	height: 					37px;
	margin:						0 0 10px 0;
}

.join-declaration-dialog .ui-dialog-content .wrapper a.button {
	display: 					block;
	width: 						110px;
	height: 					37px;
	position: 					relative;
	float: 						right;
	background: 				transparent url('common/images/button_bg.png') left top no-repeat;
	margin: 					8px 0;
	text-decoration: 			none;
}

.join-declaration-dialog .ui-dialog-content .wrapper a.button span {
	display: 					block;
	padding: 					9px 10px 10px 0;
	color: 						white;
	font-size: 					15px;
	text-shadow: 				0px 1px 1px rgba(0, 0, 0, 0.5);
	font-weight: 				600;
	background:		 			transparent url('common/images/button_bg_right.png') right top no-repeat;
	margin-left: 				10px;
	text-align: 				center;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var JoinDeclarationDialog = new Object();
JoinDeclarationDialog = {

	_content : false,	
	_product : null,

	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#join-declaration-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip', 
			'modal':true, 
			'width':540, 
			'minWidth':540,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'join-declaration-dialog',
			'title':'Join Declaration.',
			open: function() {
				JoinDeclarationDialog.show(); 
			},
			close: function(){
				JoinDeclarationDialog.hide();	
		  	}
		});	
	},
	
	launch: function()
	{
		var product = Results.getSelectedProduct();
		
		if( 
			JoinDeclarationDialog._product == null || 
			product.productId != JoinDeclarationDialog._product.productId || 
			JoinDeclarationDialog._content == false 
		)
		{
			JoinDeclarationDialog._product = product;
			
			$.ajax({
				url: "health_fund_info/" + JoinDeclarationDialog._product.info.provider.toUpperCase() + "/declaration.html",
				type: "POST",
				async: true,
				dataType: "html",
				timeout:60000,
				cache: false,
				beforeSend : function(xhr,setting) {
					var url = setting.url;
					var label = "uncache",
					url = url.replace("?_=","?" + label + "=");
					url = url.replace("&_=","&" + label + "=");
					setting.url = url;
				},
				success: function(htmlResult){
					JoinDeclarationDialog._content = htmlResult + "<div class='button-wrapper'><a href='javascript:void(0)' id='join-declaration-dialog-close' class='button next'><span>Close</span></a></div>";
					JoinDeclarationDialog.unlock();
					$("#join-declaration-dialog").find(".wrapper").first().empty().append( JoinDeclarationDialog._content );
					$('#join-declaration-dialog').dialog("open");
					return true;
				},
				error: function(obj,txt){
					JoinDeclarationDialog.lock();
					FatalErrorDialog.exec({
						message:		"Unable to load the declaration. Please try again later.",
						page:			"health:popup_join_declaration.tag",
						description:	"JoinDeclarationDialog.launch(). AJAX request failed: " + txt,
						data:			JoinDeclarationDialog._product
					});
					return false;
				}
			});
		}
		else
		{
			JoinDeclarationDialog.unlock();
			$("#join-declaration-dialog").find(".wrapper").first().empty().append( JoinDeclarationDialog._content );
			$('#join-declaration-dialog').dialog("open");
			return true;
		}
	},
	
	hide: function() {
		$("#join-declaration-dialog").hide();
	},

	show: function() {
		$("#join-declaration-dialog").show();
		$("#join-declaration-dialog-close").unbind("click");
		$("#join-declaration-dialog-close").on("click", function(){
			JoinDeclarationDialog.close()
		});
		Track.onViewJoinDeclaration( JoinDeclarationDialog._product.productId );
	},
	
	close: function(){
		$("#join-declaration-dialog").dialog("close");
	},
	
	lock: function(){
		$("#health_declaration").removeAttr("checked").attr("disabled", "true");
	},
	
	unlock: function(){
		$("#health_declaration").removeAttr("disabled");
	}
};
</go:script>
<go:script marker="onready">
JoinDeclarationDialog.init();
</go:script>