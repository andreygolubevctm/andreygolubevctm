<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Represents a single online form."%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="className" 		required="false" 	rtexprvalue="true" description="additional css class attribute"%>
<%@ attribute name="id"        		required="true"  	rtexprvalue="true" description="optional id for this slide"%>
<%@ attribute name="errorOffset"    required="false"  	rtexprvalue="true" description="Pixel offset used to position the error popup"%>
<%@ attribute name="minTop"			required="false" 	rtexprvalue="true" description="Minimum top position in pixels" %>
<%@ attribute name="overRidePosition"	required="false" 	rtexprvalue="false" description="USed to overrided the Position:fixed" %>

<c:if test="${empty errorOffset}">
	<c:set var="errorOffset" value="43" />
</c:if>
<c:if test="${empty minTop}">
	<c:set var="minTop" value="5" />
</c:if>

<!-- our error container -->
<div class="${className}" id="${id}">
		<div class="error-panel-top"><h3>Oops... We need more info</h3></div>
			<div class="error-panel-middle">
				<div class="error-list"><ul></ul></div>
			</div>
		<div class="error-panel-bottom"></div>
</div>

<%-- CSS --%>
<go:style marker="css-head">

	.error-body {
		padding: 40px 6px 0px 9px;
	}
	.error-list {
		width: 100%;
	}
	#${id} {
		padding:0px;
		right:-341px;
		top: 70px;
		float: right;
		position: absolute;
		width: 308px;
		font-size: 12px;
		color: #EA0000;
		font-weight: bold;
		z-index: 2000;
		display: none;
	}
	#${id} ul li {
		margin-top: 5px;
	}
		
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var toToggleHolder = {
		tt :	null,
		get :	function() {
					return toToggleHolder.tt;
		},
		set :	function(tt) {
					toToggleHolder.tt = tt;
		}
};

$.extend($.validator.prototype, {
	windowListenersAdded: false,
	panel_height: null,
	rePosition : function(toToggle) {
		
		var e_box = toToggle.eq(0);
		var e_con =	$("#content");
		var e_win = $(window);
		var offset = ${errorOffset};
		var minimumTop = ${minTop};
		


		if( !jQuery.isEmptyObject(e_con) && e_con.length && toToggle.length && typeof e_box == "object" && !jQuery.isEmptyObject(e_box) && e_box.attr("id") == "${id}" )
		{
			var info = {
				min_top:	e_con.offset().top - e_win.scrollTop() + offset,
				left:		e_con.offset().left - e_win.scrollLeft(),
				height:		e_con.innerHeight() - offset,
				width:		e_con.innerWidth(),
				myheight:	e_box.innerHeight(),
				myTop:		e_box.offset().top - e_win.scrollTop() + offset,
				vpheight:	e_win.height()
			};
			


			if( !isNaN(info.myheight) && info.myheight > 100 )
			{
				this.panel_height = info.myheight
			}
			else
			{
				info.myheight = this.panel_height;
			}
			


			info.new_left = info.left + info.width + 10;
			


			if( info.min_top < 0 )
			{
				if( info.height + info.min_top > info.vpheight )
				{
					info.height = info.vpheight;
					info.min_top = 5;
					info.new_top = 	info.min_top;
				}
				else if( info.height + info.min_top < info.vpheight && info.height + info.min_top >= info.myheight )
				{
					info.height = info.height + info.min_top;
					info.min_top = 5;
					info.new_top = 	info.min_top;
				}
				else if( info.height + info.min_top < info.vpheight && info.height + info.min_top < info.myheight )
				{
					info.height = info.height + info.min_top;
					info.min_top = info.height - info.myheight;
					info.new_top = 	info.min_top;
				}
				else
				{
					info.new_top = 	info.min_top + (info.height/2) - (info.myheight/2);
				}
			}
			else
			{
				info.new_top = 	info.min_top;
			}
			
			if (info.new_top < minimumTop) {
				info.new_top = minimumTop;
			}
			<c:if test="${!overRidePosition}">
			if(e_box.css("position") != "fixed")
			{
				e_box.css("position","fixed");
			}
			</c:if>
			
			if(e_box.css("right"))
			{
				e_box.css("right","");
			}
			
			<c:if test="${!overRidePosition}">
			e_box.css({
				top:		info.new_top,
				left:		info.new_left
			});
			</c:if>
		}
		
		return toToggle;
	},
	
	addWrapper: function(toToggle) {
		
		var that = this;
				
		if ( this.settings.wrapper ) {
			toToggle = toToggle.add( toToggle.parent( this.settings.wrapper ) );
		}
		
		var e_box = toToggle.eq(0);
		var e_con =	$("#content");
		
		if( !jQuery.isEmptyObject(e_con) && e_con.length && toToggle.length && typeof e_box == "object" && !jQuery.isEmptyObject(e_box) && e_box.attr("id") == "${id}" ) 
		{
			if( toToggle.length && !this.windowListenersAdded )
			{
				this.applyWindowListeners( toToggle );
			}
		}
		
		return this.rePosition(toToggle);
	},
	
	applyWindowListeners : function( toToggle )
	{
		toToggle = toToggle || toToggleHolder.get();
		
		var that = this;
		
		$(window).scroll(function(){
			that.rePosition(toToggle);
		});
		$(window).resize(function(){
			that.rePosition(toToggle);
		});
		
		toToggleHolder.set( toToggle );
		
		this.windowListenersAdded = true;
	}
});
</go:script>
<go:script marker="onready">
	$("#${id}").hide();
</go:script>