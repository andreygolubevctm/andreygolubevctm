<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 					required="true" 	rtexprvalue="true"	 description="id of the dialog" %>
<%@ attribute name="title" 					required="false" 	rtexprvalue="true"	 description="title of the dialog" %>
<%@ attribute name="titleDisplay"			required="false" 	rtexprvalue="true"	 description="whether to display the title bar or not" %>
<%@ attribute name="contentBorder"			required="false" 	rtexprvalue="true"	 description="whether to display the border around the content section of the dialog" %>
<%@ attribute name="contentBorderColor"		required="false" 	rtexprvalue="true"	 description="the color of the border around the content section of the dialog" %>
<%@ attribute name="dialogBackgroundColor"	required="false" 	rtexprvalue="true"	 description="background color of the dialog" %>
<%@ attribute name="contentBackgroundColor"	required="false" 	rtexprvalue="true"	 description="background color of the content section of the dialog" %>
<%@ attribute name="width" 					required="true"		rtexprvalue="true"	 description="width of the dialog" %>
<%@ attribute name="height" 				required="false" 	rtexprvalue="true"	 description="height of the dialog" %>
<%@ attribute name="draggable" 				required="false"	rtexprvalue="true"	 description="if the dialog is draggable" %>
<%@ attribute name="resizable" 				required="false" 	rtexprvalue="true"	 description="if the dialog is resizable" %>
<%@ attribute name="onOpen" 				required="false" 	rtexprvalue="true"	 description="some JS to be executed when opening the dialog" %>
<%@ attribute name="onCreate"	 			required="false" 	rtexprvalue="true"	 description="some JS to be executed when creating the dialog" %>
<%@ attribute name="onClose" 				required="false" 	rtexprvalue="true"	 description="some JS to be executed when closing the dialog" %>
<%@ attribute name="extraCss"	 			required="false"	rtexprvalue="true"	 description="some extra css to complement/override the default dialog styling" %>
<%@ attribute name="buttons"	 			required="false"	rtexprvalue="true"	 description="buttons to be generated in the modal" %>

<c:if test="${empty contentBorderColor}"><c:set var="contentBorderColor" value="#e3e8ec" /></c:if>
<c:if test="${empty dialogBackgroundColor}"><c:set var="dialogBackgroundColor" value="#FAFAFB" /></c:if>
<c:if test="${empty contentBackgroundColor}"><c:set var="contentBackgroundColor" value="#ffffff" /></c:if>
<c:if test="${empty titleDisplay}"><c:set var="titleDisplay" value="true" /></c:if>
<c:if test="${empty contentBorder}"><c:set var="contentBorder" value="true" /></c:if>
<c:if test="${empty height}"><c:set var="height" value="'auto'" /></c:if>
<c:if test="${empty draggable}"><c:set var="draggable" value="false" /></c:if>
<c:if test="${empty resizable}"><c:set var="resizable" value="false" /></c:if>

<%-- HTML --%>
<div id="${id}Dialog">
	<a href="#" class="dialogHackLink">
		...
		<%-- Jquery UI Dialog Hack - this link needs to stay here, otherwise the dialog scrolls to the first tabbable/focusable element of the content
		If your scrollable area is not the main content div, then you need to add a similar link at the top of the area to avoid the scrolling of that div too. --%>
	</a>
	<jsp:doBody />
</div>

<%-- JAVASCRIPT --%>
<go:script marker="jquery-ui">

$("#${id}Dialog").dialog({
	title: "${title}",
	autoOpen: false,
	hide: {
		effect: 'clip',
		complete: function(){

		}
	},
	show: {
		effect: 'clip',
		complete: function() {
			$("#${id}Dialog").dialog("option", "position", "center");
		}
	},
	'zIndex': 20000,
	'modal':true,
	'width':${width},
	'height':${height},
	'minWidth':${width},
	'minHeight':${height},
	'draggable':${draggable},
	'resizable':${resizable},
	open: function(event, ui) {
		$(".${id}Dialog").show();

		$('#${id}Dialog').css({'max-height': ($(window).height()-150)});

		$(".ui-widget-overlay").last().on("click", function(){
			${id}Dialog.close();
		});

		$(".${id}DialogContainer.ui-dialog").removeClass('ui-corner-all').addClass("ui-corner-bottom");

		${onOpen}

	},
	close: function(){
		$(".${id}Dialog").hide();

		${onClose}
	},
	create: function(e, ui) {
		$(this).dialog('widget').find('.ui-dialog-titlebar').removeClass('ui-corner-all');

		$(this).dialog('widget').find('.ui-dialog-content').addClass('ui-corner-all');

		$(this).dialog('widget').append('<div class="dialogHeader ${id}Dialog"><div class="dialogHeaderLeft"></div><div class="dialogHeaderRight"></div></div>');
		$(this).dialog('widget').append('<div class="dialogClose ${id}Dialog" onclick="${id}Dialog.close()"></div>');

		${onCreate}
	},
	dialogClass: '${id}DialogContainer'
	<c:if test="${not empty buttons}">
	,'buttons': ${buttons}
	</c:if>
});

</go:script>

<go:script marker="js-head">
var ${id}Dialog = {
	open: function(callback){

		${id}Dialog.actionCallback(callback, 'show');

		$('#${id}Dialog').dialog('open');
		return false;
	},

	close: function(callback){

		/*
		@todo = there does not seem to be a "complete" callback for the dialog's hide animation
		which is weird cause there is one for the open callback, see above
		*/
		// ${id}Dialog.actionCallback(callback, 'hide');

		$('#${id}Dialog').dialog('close');

		// callback is called without waiting for the animation to finish, see issue explained above
		if( typeof callback == "function" ) {
			callback();
		}
	},

	actionCallback: function(callback, action){

		var options = $('#${id}Dialog').dialog( 'option', action);

		if( typeof callback == "function" ) {

			// copy current complete callback function
			var optionsComplete = options.complete;

			// combine it with the callback function received into a new function
			var combinedComplete = function(){
				optionsComplete();
				callback();
			}

			// replace the complete function with the combined one
			options.complete = combinedComplete;

		}
		$('#${id}Dialog').dialog( 'option', action, options );
	},

	dialog: function(options) {
		//var args = arguments;
		//Was trying to make sure that this passed multiple arguments through correctly to the dialog call below, but not sure why it's not working - KV.
		var theObject = $('#${id}Dialog').dialog(options);
		return theObject;
	}

};
</go:script>

<go:script marker="onready">
	$(window).resize(function() {
		$("#${id}Dialog").dialog("option", "position", "center");
	});
</go:script>

<%-- CSS --%>
<go:style marker="css-head">
	#${id}Dialog{
		display: none;
	}

	#${id}Dialog #content{
		width: auto;
	}

	a.dialogHackLink{
		margin-left: -9999px;
		position: absolute;
	}

	.${id}DialogContainer.ui-dialog{
		background: none;
		background-image: none;
		background-color: ${dialogBackgroundColor};
	}

	.${id}DialogContainer .ui-dialog-titlebar{
		background: none;
	}

	.${id}DialogContainer.ui-dialog .ui-dialog-content{
		background: none;
		background-image: none !important;
		background-color: ${contentBackgroundColor};

		<c:if test="${contentBorder == true}">
		border: 1px solid ${contentBorderColor};
		</c:if>

		padding: .5em 0.5em;
		margin: 0 0.5em 7px 0.5em;
	}

	.${id}DialogContainer.ui-dialog .ui-dialog-content iframe{
		width: 99.8%;
	}

	<c:set var="widthHeader" value="${width - 4}" />
	.${id}DialogContainer .dialogHeader{
		position: absolute;
		top: -4px;
		width: ${widthHeader}px
	}
		.${id}DialogContainer .dialogHeaderLeft{
			position: absolute;
			background: url(common/images/dialog/header-left.png) top left no-repeat;
			width: 29px;
			height: 4px;
		}
		.${id}DialogContainer .dialogHeaderRight{
			position: absolute;
			background: url(common/images/dialog/header-right.png) top right no-repeat;
			width: ${widthHeader}px;
			height: 4px;
			z-index: -1;
			right: -4px
		}

	.${id}DialogContainer .dialogClose {
		background: url(common/images/dialog/close.png) no-repeat;
		width: 39px;
		height: 31px;
		position: absolute;
		top: 5px;
		right: 0px;
		cursor: pointer;
		display: none;
	}

	<c:if test="${titleDisplay == false}">
		.${id}DialogContainer .ui-dialog-titlebar{
			height: 6px;
			padding: 0 !important;
		}
		.${id}DialogContainer .ui-dialog-titlebar span{
			display: none;
		}
		.${id}DialogContainer .dialogClose {
			background: url(common/images/dialog/close.png) no-repeat;
			width: 36px;
			height: 31px;
			position: absolute;
			top: -40px;
			right: -7px;
			cursor: pointer;
			display: none;
		}
	</c:if>

	${extraCss}
</go:style>