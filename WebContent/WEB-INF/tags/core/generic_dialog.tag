<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>


<%--
//RESOLVE:
create an object handler to properyl address any attributes after _html and _title.
NOTE: most dialog pops come from an a href so will need to be able to handle being part of an html attribute.
 --%>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var generic_dialog = {
	display: function(_html,_title){
		if(typeof _title == "undefined" ||  _title == ''){
			_title = 'Information';
		};
		generic_dialog.$_dialog = $(document.createElement('div')).html(_html + '<div class="dialog_footer"></div>');
		$(generic_dialog.$_dialog).dialog({ 'width':637,'height':280,'modal':true,'title':_title, 'dialogClass':'generic_dialog' });
	},
	close: function(){
		$(generic_dialog.$_dialog).dialog("close");
	}
};
</go:script>
<go:script marker="onready">
	$('form').on('click','.dialogPop',function(){
		generic_dialog.display($(this).attr('data-content'),$(this).attr('title'));
	});
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	.generic_dialog .dialog_footer {
		position:				absolute;
		left:					0;
		bottom:					0;
		background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
		width: 					637px;
		height: 				14px;
		clear: 					both;
	}
	
	.generic_dialog .ui-dialog-titlebar-close {
		display: 				block !important;
		top: 					2.5em;
		right: 					1em;
	}
	
	a.dialogPop {
		text-decoration: underline;
		cursor:pointer;
	}
		
</go:style>