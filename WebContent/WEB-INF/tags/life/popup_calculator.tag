<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<%-- HTML --%>
<a href="javascript:void(0);" class="lb-calculator"><!-- empty --></a>

<div id="lb-calculator-dialog" class="lb-calculator-dialog" title="Callback Confirmation">
	<div class="dialog_header"><!-- empty --></div>
	<div class="wrapper">
		<iframe id="calculator_box" seamless="seamless" src="external/life/calculator/lifebroker-insurance-calculator.html" align="middle" frameborder="0" height="302px" width="500px" scrolling="no">
		</iframe>
	</div>
	<div class="dialog_footer"><!-- empty --></div>
</div>


<%-- CSS --%>
<go:style marker="css-head">

#calculator_box {
	display:block;
	height:302px;
	width:500px;
}
	
.lb-calculator {
	display: block;
	position: absolute;
	width: 104px;
	height: 69px;
	top: 15px;
	right: 0px;
	cursor: pointer;
	background: transparent url(external/life/calculator/icon_calculator.png)  top left no-repeat;
}	
.lb-calculator:hover {
	background-position: bottom left;
}

#lb-calculator-dialog {
	min-width:				540px;
	max-width:				540px;
	width:					540px;
	display: 				none;
	overflow:				hidden;
	padding:				0 !important;
}

#lb-calculator-dialog a {
	font-size:100%;
}

#lb-calculator-dialog .clear{clear:both;}

#lb-calculator-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_540.gif") no-repeat scroll left top transparent;
	width: 					540px;
	height: 				10px;
	clear: 					both;
}

#lb-calculator-dialog .dialog_header {
	position:				absolute;
	left:					0;
	top:					0;
	background: 			url("brand/ctm/images/ui-dialog-header_540_under.gif") no-repeat scroll left bottom transparent;
	width: 					540px;
	height: 				10px;
	clear: 					both;
}

.ui-dialog.lb-calculator-dialog .ui-dialog-titlebar {
	padding: 				0 !important;
	height: 				25px !important;
}

.ui-dialog.lb-calculator-dialog .ui-dialog-titlebar .ui-dialog-title {
	display: 				none !important;
}

.ui-dialog.lb-calculator-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					15px !important;
	right: 					1em;
}

.lb-calculator-dialog .ui-dialog-titlebar {
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

.lb-calculator-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_540.png") !important;
}

.lb-calculator-dialog .ui-dialog-content .wrapper {
	padding:					15px 20px;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var LBCalculatorDialog = new Object();
LBCalculatorDialog = {

	init: function() {
	
		// Initialise the search quotes dialog box
		// =======================================
		$('#lb-calculator-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip', 
			'modal':true, 
			'width':540, 
			'minWidth':540,  
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'lb-calculator-dialog',
			'title':'Confirm Contact.',
			open: function() {
				LBCalculatorDialog.show(); 
			},
			close: function(){
				LBCalculatorDialog.hide();	
		  	}
		});	
		
		if( $(".lb-calculator") ) {
			$(".lb-calculator").each(function(){
				$(this).on("click", function(){
					LBCalculatorDialog.launch();
				});
			});
		}
	},
	
	launch: function()
	{
		$('#lb-calculator-dialog').dialog("open");
		$('#calculator_box').hide().fadeIn();
	},
	
	hide: function() {
		$("#lb-calculator-dialog").hide();
	},

	show: function() {
		$("#lb-calculator-dialog").show();
	},
	
	close: function( callback ) {
		$("#lb-calculator-dialog").dialog("close");
	}
};
</go:script>
<go:script marker="onready">
LBCalculatorDialog.init();
</go:script>