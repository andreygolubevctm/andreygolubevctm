<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%--
This tag renders a button on the page which can trigger a form for
the user to request a callback from the Call Centre.
--%>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="true" rtexprvalue="true"	description="ID to assign to parent element" %>
<%@ attribute name="className"	required="false" rtexprvalue="true"	description="Class assigned to parent element" %>
<%@ attribute name="minWidth"	required="true" rtexprvalue="true"	description="Minimum width of the parent element" %>
<%@ attribute name="maxWidth"	required="true" rtexprvalue="true"	description="Maximum width of the parent element" %>
<%@ attribute name="height"		required="true" rtexprvalue="true"	description="Height of the parent element" %>

<%-- HTML --%>
<div id="${id}" class="${className}">
	<a href="javascript:void(0);" id="${id}_close"><!-- close dialog button --></a>
	<jsp:doBody />
</div>

<%-- SCRIPT --%>
<go:script marker="js-head">
/** Class injects a button onto the
  */
var ${fn:toUpperCase(id)} = function() {

	// Private members area
	var that			= this,
		min_width		= ${minWidth},
		max_width		= ${maxWidth},
		height			= ${height},
		elements		= {};

	// Create elements and add events
	this.init = function() {
		$('body').append("<div id='${id}_mask'><!-- empty --></div>");

		elements = {
			popup	: $('#${id}'),
			close	: $('#${id}_close'),
			mask	: $('#${id}_mask')
		};

		$('#${id}_mask').on('click', that.hide);
		$('#${id}_close').on('click', that.hide);
	};

	this.show = function() {

		var viewportWidth	= jQuery(window).width(),
			viewportHeight	= jQuery(window).height(),
			elOffset 		= elements.popup.offset();

		var width = max_width;
		<%-- Ignore for now until/if we decide to implement flexible popups
		if( viewportWidth < min_width ) {
			width = min_width;
		} else if( viewportWidth > min_width && viewportWidth < max_width ) {
			width = Math.ceil(viewportWidth * 0.95);
		}--%>

		elements.mask.css({height:$(document).height()});
		elements.popup.css({
			width:	width,
			height: height
		});

		elWidth 		= elements.popup.width(),
		elHeight 		= elements.popup.height(),

		elements.popup.css({
			top:	(viewportHeight/2) - (elHeight/2),
			left:	(viewportWidth/2) - (elWidth/2)
		});

		elements.mask.show(200, function(){
			elements.popup.show().animate({opacity:1}, 400);
		});
	};

	this.hide = function() {
		elements.popup.animate({opacity:0}, 400, function(){
			elements.popup.hide();
			elements.mask.hide(200);
		});
	};

	var getHighestZIndex = function() {
		var maxZ = Math.max.apply(null,$.map($('body > *'), function(e,n){
				var index = parseInt($(e).css('z-index'))||1 ;
				return isNaN(index) ? 0 : index;
			})
		);
	};
};

var ${id} = new ${fn:toUpperCase(id)}();
</go:script>
<go:script marker="onready">
${id}.init();
</go:script>

<%-- STYLE --%>
<go:style marker="css-head">
#${id}_mask {
	position: 			absolute;
	left: 				0;
	right: 				0;
	top: 				0;
	bottom: 			0;
	z-index: 			1000;
	background: 		url(brand/ctm/competition/meerkat_rewards/img/mask.png) top left repeat;
	opacity: 			0.4;
	-ms-filter: 		"progid:DXImageTransform.Microsoft.Alpha(Opacity=40)";
	filter: 			alpha(opacity=40);
	visibility: 		visible;
	display:			none;
}

#${id} {
	position: 			fixed;
	width:				1px;
	height:				1px;
	left: 				0;
	top: 				0;
	z-index: 			1001;
	opacity:			0;
	display:			none;
}

#${id}_close {
	position: 			absolute;
	width:				31px;
	height:				31px;
	right: 				-8px;
	top: 				-8px;
	z-index: 			1002;
	background:			transparent url(brand/ctm/competition/meerkat_rewards/img/close.png) top left no-repeat;
	display:			block;
}
</go:style>